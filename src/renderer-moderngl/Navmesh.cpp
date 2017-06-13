/*
	TE4 - T-Engine 4
	Copyright (C) 2009 - 2017 Nicolas Casalini

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.

	Nicolas Casalini "DarkGod"
	darkgod@te4.org
*/

extern "C" {
#include "lua.h"
#include "lauxlib.h"
#include "display.h"
#include "types.h"
#include "physfs.h"
#include "physfsrwops.h"
#include "main.h"
}

#include "poly2tri/poly2tri.h"
#include "Recast.h"
#include "RecastDebugDraw.h"
#include "RecastDump.h"
#include "renderer-moderngl/Navmesh.hpp"

Navmesh::Navmesh(b2World *world) : world(world) {
}

Navmesh::~Navmesh() {
}

void Navmesh::extractShapePolygon(b2Body *body, b2PolygonShape *shape) {
	vec2 center = getCoords(body->GetWorldCenter());
	int nb = shape->GetVertexCount();
	int i = 0;
	vec2 v0 = getCoords(shape->GetVertex(i)) + center;
	for (i = 1; i < nb - 1; i++) {
		vec2 v1 = getCoords(shape->GetVertex(i)) + center;
		vec2 v2 = getCoords(shape->GetVertex(i+1)) + center;
		mesh.push_back({{v0.x, v0.y}, {v1.x, v1.y}, {v2.x, v2.y}});
	}
}

template <class C> void FreeClear( C & cntr ) {
	for ( typename C::iterator it = cntr.begin(); it != cntr.end(); ++it ) {
		delete * it;
	}
	cntr.clear();
}

void Navmesh::extractShapeChain(b2Body *body, b2ChainShape *shape) {
	vec2 center = getCoords(body->GetWorldCenter());
	vector<p2t::Point*> vertices;
	vertices.reserve(shape->m_count);
	for (int i = 0; i < shape->m_count; i++) {
		if (i == shape->m_count-1 && shape->m_vertices[0].x == shape->m_vertices[i].x && shape->m_vertices[0].y == shape->m_vertices[i].y) {
			printf("Loop detected, ignoring last poing\n");
			break;
		}
		vec2 v = getCoords(shape->m_vertices[i]);
		vertices.push_back(new p2t::Point({v.x + center.x, v.y + center.y}));
	}
	p2t::CDT cdt(vertices);
	cdt.Triangulate();
	vector<p2t::Triangle*> triangles = cdt.GetTriangles();

	int nb = 1;
	for (auto &tri : triangles) {
		p2t::Point *p1 = tri->GetPoint(0);
		p2t::Point *p2 = tri->GetPoint(1);
		p2t::Point *p3 = tri->GetPoint(2);
		mesh.push_back({{p1->x, p1->y}, {p2->x, p2->y}, {p3->x, p3->y}});
		nb++;
	}

	FreeClear(vertices);
	
	// int nb = shape->m_count;
	// int i = 0;
	// vec2 v0 = getCoords(shape->m_vertices[i]);
	// for (i = 1; i < nb - 1; i++) {
	// 	vec2 v1 = getCoords(shape->m_vertices[i]);
	// 	vec2 v2 = getCoords(shape->m_vertices[i+1]);
	// 	printf(" * %fx%f  ;;  %fx%f  ;;  %fx%f\n", v0.x, v0.y, v1.x, v1.y, v2.x, v2.y);
	// }
}

bool Navmesh::build() {
	// Parse the static (only) bodies, extract shapes and extrapolate trinagles from them
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext()) { if (b->GetType() == b2_staticBody) {
		for (b2Fixture* f = b->GetFixtureList(); f; f = f->GetNext()) {
			b2Shape *shape = f->GetShape();
			switch (shape->GetType()) {
				case b2Shape::Type::e_polygon: {
					extractShapePolygon(b, dynamic_cast<b2PolygonShape*>(shape));
					break;
				}
				case b2Shape::Type::e_chain: {
					extractShapeChain(b, dynamic_cast<b2ChainShape*>(shape));
					break;
				}
			}
		}
	} }

	// With the triangles compute the navmesh
	makeNavmesh();
	return true;
}

bool Navmesh::makeNavmesh() {
	unsigned char* m_triareas;
	rcHeightfield* m_solid;
	rcCompactHeightfield* m_chf;
	rcContourSet* m_cset;
	rcPolyMesh* m_pmesh;
	rcConfig m_cfg;	
	rcPolyMeshDetail* m_dmesh;
	rcContext m_ctx(false);

	float bmin[3] = {999999, 999999, -1}, bmax[3] = {-999999, -999999, 1};


	float m_cellSize = 9.0 ;//0.3;
	float m_cellHeight = 6.0 ;//0.2;
	float m_agentMaxSlope = 45;
	float m_agentHeight = 64.0;
	float m_agentMaxClimb = 16;
	float m_agentRadius = 16;
	float m_edgeMaxLen = 512;
	float m_edgeMaxError = 1.3;
	float m_regionMinSize = 50;
	float m_regionMergeSize = 20;
	float m_vertsPerPoly = 6;
	float m_detailSampleDist = 6;
	float m_detailSampleMaxError = 1;
	float m_keepInterResults = false;

	// Init build configuration from GUI
	memset(&m_cfg, 0, sizeof(m_cfg));
	m_cfg.cs = m_cellSize;
	m_cfg.ch = m_cellHeight;
	m_cfg.walkableSlopeAngle = m_agentMaxSlope;
	m_cfg.walkableHeight = (int)ceilf(m_agentHeight / m_cfg.ch);
	m_cfg.walkableClimb = (int)floorf(m_agentMaxClimb / m_cfg.ch);
	m_cfg.walkableRadius = (int)ceilf(m_agentRadius / m_cfg.cs);
	m_cfg.maxEdgeLen = (int)(m_edgeMaxLen / m_cellSize);
	m_cfg.maxSimplificationError = m_edgeMaxError;
	m_cfg.minRegionArea = (int)rcSqr(m_regionMinSize);		// Note: area = size*size
	m_cfg.mergeRegionArea = (int)rcSqr(m_regionMergeSize);	// Note: area = size*size
	m_cfg.maxVertsPerPoly = (int)m_vertsPerPoly;
	m_cfg.detailSampleDist = m_detailSampleDist < 0.9f ? 0 : m_cellSize * m_detailSampleDist;
	m_cfg.detailSampleMaxError = m_cellHeight * m_detailSampleMaxError;
	
	// Set the area where the navigation will be build.
	// Here the bounds of the input mesh are used, but the
	// area could be specified by an user defined box, etc.
	rcVcopy(m_cfg.bmin, bmin);
	rcVcopy(m_cfg.bmax, bmax);
	rcCalcGridSize(m_cfg.bmin, m_cfg.bmax, m_cfg.cs, &m_cfg.width, &m_cfg.height);

	// Allocate voxel heightfield where we rasterize our input data to.
	m_solid = rcAllocHeightfield();
	if (!rcCreateHeightfield(&m_ctx, *m_solid, m_cfg.width, m_cfg.height, m_cfg.bmin, m_cfg.bmax, m_cfg.cs, m_cfg.ch))
	{
		printf("buildNavigation: Could not create solid heightfield.\n");
		return false;
	}
	
	// Allocate array that can hold triangle area types.
	// If you have multiple meshes you need to process, allocate
	// and array which can hold the max number of triangles you need to process.
	m_triareas = new unsigned char[ntris];
	
	// Find triangles which are walkable based on their slope and rasterize them.
	// If your input data is multiple meshes, you can transform them here, calculate
	// the are type for each of the meshes and rasterize them.
	memset(m_triareas, 0, ntris*sizeof(unsigned char));
	rcMarkWalkableTriangles(&m_ctx, m_cfg.walkableSlopeAngle, verts, nverts, tris, ntris, m_triareas);
	if (!rcRasterizeTriangles(&m_ctx, verts, nverts, tris, m_triareas, ntris, *m_solid, m_cfg.walkableClimb))
	{
		printf("buildNavigation: Could not rasterize triangles.\n");
		return false;
	}

	if (!m_keepInterResults)
	{
		delete [] m_triareas;
		m_triareas = 0;
	}
	
	//
	// Step 3. Filter walkables surfaces.
	//
	
	// Once all geoemtry is rasterized, we do initial pass of filtering to
	// remove unwanted overhangs caused by the conservative rasterization
	// as well as filter spans where the character cannot possibly stand.
	if (m_filterLowHangingObstacles)
		rcFilterLowHangingWalkableObstacles(&m_ctx, m_cfg.walkableClimb, *m_solid);
	if (m_filterLedgeSpans)
		rcFilterLedgeSpans(&m_ctx, m_cfg.walkableHeight, m_cfg.walkableClimb, *m_solid);
	if (m_filterWalkableLowHeightSpans)
		rcFilterWalkableLowHeightSpans(&m_ctx, m_cfg.walkableHeight, *m_solid);


	//
	// Step 4. Partition walkable surface to simple regions.
	//

	// Compact the heightfield so that it is faster to handle from now on.
	// This will result more cache coherent data as well as the neighbours
	// between walkable cells will be calculated.
	m_chf = rcAllocCompactHeightfield();
	if (!rcBuildCompactHeightfield(&m_ctx, m_cfg.walkableHeight, m_cfg.walkableClimb, *m_solid, *m_chf))
	{
		printf("buildNavigation: Could not build compact data.\n");
		return false;
	}
	
	if (!m_keepInterResults)
	{
		rcFreeHeightField(m_solid);
		m_solid = 0;
	}
		
	// Erode the walkable area by agent radius.
	if (!rcErodeWalkableArea(&m_ctx, m_cfg.walkableRadius, *m_chf))
	{
		printf("buildNavigation: Could not erode.\n");
		return false;
	}

	// (Optional) Mark areas.
	const ConvexVolume* vols = m_geom->getConvexVolumes();
	for (int i  = 0; i < m_geom->getConvexVolumeCount(); ++i)
		rcMarkConvexPolyArea(&m_ctx, vols[i].verts, vols[i].nverts, vols[i].hmin, vols[i].hmax, (unsigned char)vols[i].area, *m_chf);

	
	// Partition the heightfield so that we can use simple algorithm later to triangulate the walkable areas.
	// There are 3 martitioning methods, each with some pros and cons:
	// 1) Watershed partitioning
	//   - the classic Recast partitioning
	//   - creates the nicest tessellation
	//   - usually slowest
	//   - partitions the heightfield into nice regions without holes or overlaps
	//   - the are some corner cases where this method creates produces holes and overlaps
	//      - holes may appear when a small obstacles is close to large open area (triangulation can handle this)
	//      - overlaps may occur if you have narrow spiral corridors (i.e stairs), this make triangulation to fail
	//   * generally the best choice if you precompute the nacmesh, use this if you have large open areas
	// 2) Monotone partioning
	//   - fastest
	//   - partitions the heightfield into regions without holes and overlaps (guaranteed)
	//   - creates long thin polygons, which sometimes causes paths with detours
	//   * use this if you want fast navmesh generation
	// 3) Layer partitoining
	//   - quite fast
	//   - partitions the heighfield into non-overlapping regions
	//   - relies on the triangulation code to cope with holes (thus slower than monotone partitioning)
	//   - produces better triangles than monotone partitioning
	//   - does not have the corner cases of watershed partitioning
	//   - can be slow and create a bit ugly tessellation (still better than monotone)
	//     if you have large open areas with small obstacles (not a problem if you use tiles)
	//   * good choice to use for tiled navmesh with medium and small sized tiles
	
	// if (m_partitionType == SAMPLE_PARTITION_WATERSHED)
	// {
		// Prepare for region partitioning, by calculating distance field along the walkable surface.
		if (!rcBuildDistanceField(&m_ctx, *m_chf))
		{
			printf("buildNavigation: Could not build distance field.\n");
			return false;
		}
		
		// Partition the walkable surface into simple regions without holes.
		if (!rcBuildRegions(&m_ctx, *m_chf, 0, m_cfg.minRegionArea, m_cfg.mergeRegionArea))
		{
			printf("buildNavigation: Could not build watershed regions.\n");
			return false;
		}
	// }
	// else if (m_partitionType == SAMPLE_PARTITION_MONOTONE)
	// {
	// 	// Partition the walkable surface into simple regions without holes.
	// 	// Monotone partitioning does not need distancefield.
	// 	if (!rcBuildRegionsMonotone(&m_ctx, *m_chf, 0, m_cfg.minRegionArea, m_cfg.mergeRegionArea))
	// 	{
	// 		printf("buildNavigation: Could not build monotone regions.\n");
	// 		return false;
	// 	}
	// }
	// else // SAMPLE_PARTITION_LAYERS
	// {
	// 	// Partition the walkable surface into simple regions without holes.
	// 	if (!rcBuildLayerRegions(&m_ctx, *m_chf, 0, m_cfg.minRegionArea))
	// 	{
	// 		printf("buildNavigation: Could not build layer regions.\n");
	// 		return false;
	// 	}
	// }
	
	//
	// Step 5. Trace and simplify region contours.
	//
	
	// Create contours.
	m_cset = rcAllocContourSet();
	if (!m_cset)
	{
		printf("buildNavigation: Out of memory 'cset'.\n");
		return false;
	}
	if (!rcBuildContours(&m_ctx, *m_chf, m_cfg.maxSimplificationError, m_cfg.maxEdgeLen, *m_cset))
	{
		printf("buildNavigation: Could not create contours.\n");
		return false;
	}
	
	//
	// Step 6. Build polygons mesh from contours.
	//
	
	// Build polygon navmesh from the contours.
	m_pmesh = rcAllocPolyMesh();
	if (!m_pmesh)
	{
		printf("buildNavigation: Out of memory 'pmesh'.\n");
		return false;
	}
	if (!rcBuildPolyMesh(&m_ctx, *m_cset, m_cfg.maxVertsPerPoly, *m_pmesh))
	{
		printf("buildNavigation: Could not triangulate contours.\n");
		return false;
	}
	
	//
	// Step 7. Create detail mesh which allows to access approximate height on each polygon.
	//
	
	m_dmesh = rcAllocPolyMeshDetail();
	if (!m_dmesh)
	{
		printf("buildNavigation: Out of memory 'pmdtl'.\n");
		return false;
	}

	if (!rcBuildPolyMeshDetail(&m_ctx, *m_pmesh, *m_chf, m_cfg.detailSampleDist, m_cfg.detailSampleMaxError, *m_dmesh))
	{
		printf("buildNavigation: Could not build detail mesh.\n");
		return false;
	}

	if (!m_keepInterResults)
	{
		rcFreeCompactHeightfield(m_chf);
		m_chf = 0;
		rcFreeContourSet(m_cset);
		m_cset = 0;
	}

	// At this point the navigation mesh data is ready, you can access it from m_pmesh.
	// See duDebugDrawPolyMesh or dtCreateNavMeshData as examples how to access the data.
	
	//
	// (Optional) Step 8. Create Detour data from Recast poly mesh.
	//
	
	// The GUI may allow more max points per polygon than Detour can handle.
	// Only build the detour navmesh if we do not exceed the limit.
	if (m_cfg.maxVertsPerPoly <= DT_VERTS_PER_POLYGON)
	{
		unsigned char* navData = 0;
		int navDataSize = 0;

		// Update poly flags from areas.
		for (int i = 0; i < m_pmesh->npolys; ++i)
		{
			if (m_pmesh->areas[i] == RC_WALKABLE_AREA)
				m_pmesh->areas[i] = SAMPLE_POLYAREA_GROUND;
				
			if (m_pmesh->areas[i] == SAMPLE_POLYAREA_GROUND ||
				m_pmesh->areas[i] == SAMPLE_POLYAREA_GRASS ||
				m_pmesh->areas[i] == SAMPLE_POLYAREA_ROAD)
			{
				m_pmesh->flags[i] = SAMPLE_POLYFLAGS_WALK;
			}
			else if (m_pmesh->areas[i] == SAMPLE_POLYAREA_WATER)
			{
				m_pmesh->flags[i] = SAMPLE_POLYFLAGS_SWIM;
			}
			else if (m_pmesh->areas[i] == SAMPLE_POLYAREA_DOOR)
			{
				m_pmesh->flags[i] = SAMPLE_POLYFLAGS_WALK | SAMPLE_POLYFLAGS_DOOR;
			}
		}


		dtNavMeshCreateParams params;
		memset(&params, 0, sizeof(params));
		params.verts = m_pmesh->verts;
		params.vertCount = m_pmesh->nverts;
		params.polys = m_pmesh->polys;
		params.polyAreas = m_pmesh->areas;
		params.polyFlags = m_pmesh->flags;
		params.polyCount = m_pmesh->npolys;
		params.nvp = m_pmesh->nvp;
		params.detailMeshes = m_dmesh->meshes;
		params.detailVerts = m_dmesh->verts;
		params.detailVertsCount = m_dmesh->nverts;
		params.detailTris = m_dmesh->tris;
		params.detailTriCount = m_dmesh->ntris;
		params.offMeshConVerts = m_geom->getOffMeshConnectionVerts();
		params.offMeshConRad = m_geom->getOffMeshConnectionRads();
		params.offMeshConDir = m_geom->getOffMeshConnectionDirs();
		params.offMeshConAreas = m_geom->getOffMeshConnectionAreas();
		params.offMeshConFlags = m_geom->getOffMeshConnectionFlags();
		params.offMeshConUserID = m_geom->getOffMeshConnectionId();
		params.offMeshConCount = m_geom->getOffMeshConnectionCount();
		params.walkableHeight = m_agentHeight;
		params.walkableRadius = m_agentRadius;
		params.walkableClimb = m_agentMaxClimb;
		rcVcopy(params.bmin, m_pmesh->bmin);
		rcVcopy(params.bmax, m_pmesh->bmax);
		params.cs = m_cfg.cs;
		params.ch = m_cfg.ch;
		params.buildBvTree = true;
		
		if (!dtCreateNavMeshData(&params, &navData, &navDataSize))
		{
			printf("Could not build Detour navmesh.\n");
			return false;
		}
		
		m_navMesh = dtAllocNavMesh();
		if (!m_navMesh)
		{
			dtFree(navData);
			printf("Could not create Detour navmesh\n");
			return false;
		}
		
		dtStatus status;
		
		status = m_navMesh->init(navData, navDataSize, DT_TILE_FREE_DATA);
		if (dtStatusFailed(status))
		{
			dtFree(navData);
			printf("Could not init Detour navmesh\n");
			return false;
		}
		
		status = m_navQuery->init(m_navMesh, 2048);
		if (dtStatusFailed(status))
		{
			printf("Could not init Detour navmesh query\n");
			return false;
		}
	}
	
	m_ctx->stopTimer(RC_TIMER_TOTAL);

}

extern int gl_tex_white;
void Navmesh::drawDebug(float x, float y) {
	if (!renderer) { 
		renderer = new RendererGL(VBOMode::STREAM);
		char *name = strdup("navmesh debug renderer");
		renderer->setRendererName(name, false);
		renderer->setManualManagement(true);
	}

	renderer->resetDisplayLists();
	renderer->setChanged(true);

	auto dl = getDisplayList(renderer, {(GLuint)gl_tex_white, 0, 0}, NULL, VERTEX_MAP_INFO, RenderKind::TRIANGLES);
	for (auto &tri : mesh) {
		vertex v1{{tri.p1.x, tri.p1.y, 0, 1}, {0, 0}, {0, 1, 0.5, 0.5}};
		vertex v2{{tri.p2.x, tri.p2.y, 0, 1}, {0, 0}, {0, 1, 0.5, 0.5}};
		vertex v3{{tri.p3.x, tri.p3.y, 0, 1}, {0, 0}, {0, 1, 0.5, 0.5}};
		dl->list.push_back(v1);
		dl->list.push_back(v2);
		dl->list.push_back(v3);
	}

	dl = getDisplayList(renderer, {(GLuint)gl_tex_white, 0, 0}, NULL, VERTEX_MAP_INFO, RenderKind::LINES);
	for (auto &tri : mesh) {
		vertex v1{{tri.p1.x, tri.p1.y, 0, 1}, {0, 0}, {0, 1, 1, 1}};
		vertex v2{{tri.p2.x, tri.p2.y, 0, 1}, {0, 0}, {0, 1, 1, 1}};
		vertex v3{{tri.p3.x, tri.p3.y, 0, 1}, {0, 0}, {0, 1, 1, 1}};
		dl->list.push_back(v1); dl->list.push_back(v2);
		dl->list.push_back(v2); dl->list.push_back(v3);
		dl->list.push_back(v3); dl->list.push_back(v1);
	}

	glm::mat4 model = glm::mat4();
	model = glm::translate(model, glm::vec3(x, y, 0.f));
	renderer->toScreen(model, {1,1,1,1});
}