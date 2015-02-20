/*
    TE4 - T-Engine 4
    Copyright (C) 2009 - 2015 Nicolas Casalini

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
#include "display.h"
#include "types.h"
#include "physfs.h"
#include "physfsrwops.h"
#include "renderer.h"
}

#include "renderer-gl.hpp"

// static RendererState *state;

vertexes_renderer* vertexes_renderer_new(vertex_mode kind, render_mode mode) {
	vertexes_renderer *vr = (vertexes_renderer*)malloc(sizeof(vertexes_renderer));
	glGenBuffers(1, &vr->vbo);
	if (mode == VERTEX_STATIC) vr->mode = GL_STATIC_DRAW;
	if (mode == VERTEX_DYNAMIC) vr->mode = GL_DYNAMIC_DRAW;
	if (mode == VERTEX_STREAM) vr->mode = GL_STREAM_DRAW;
	if (kind == VO_POINTS) vr->kind = GL_POINTS;
	if (kind == VO_QUADS) vr->kind = GL_QUADS;
	if (kind == VO_TRIANGLE_FAN) vr->kind = GL_TRIANGLE_FAN;
	return vr;
}

void vertexes_renderer_free(vertexes_renderer *vr) {
	glDeleteBuffers(1, &vr->vbo);
	free(vr);
}

void vertexes_renderer_toscreen(vertexes_renderer *vr, lua_vertexes *vx, float x, float y, float r, float g, float b, float a) {
	tglBindTexture(GL_TEXTURE_2D, vx->tex);
	glTranslatef(x, y, 0);

	// Modern(ish) OpenGL way
	if (shaders_active) {
		shader_type *shader;

		if (!current_shader) {
			useNoShader();
			if (!current_shader) return;
		}

		shader = current_shader;
		if (shader->vertex_attrib == -1) return;

		if (shader->p_color != -1) {
			GLfloat d[4];
			d[0] = r;
			d[1] = g;
			d[2] = b;
			d[3] = a;
			glUniform4fvARB(shader->p_color, 1, d);
		}

		glBindBuffer(GL_ARRAY_BUFFER, vr->vbo);
		if (vx->changed) {
			// glBufferData(GL_ARRAY_BUFFER, sizeof(vertex_data) * vx->nb, vx->vertices, vr->mode);
			glBufferData(GL_ARRAY_BUFFER, sizeof(vertex_data) * vx->nb, NULL, vr->mode);
			glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(vertex_data) * vx->nb, vx->vertices);
		}

		glEnableVertexAttribArray(shader->vertex_attrib);
		glVertexAttribPointer(shader->vertex_attrib, 2, GL_FLOAT, GL_FALSE, sizeof(vertex_data), 0);
		if (shader->texcoord_attrib != -1) {
			glEnableVertexAttribArray(shader->texcoord_attrib);
			glVertexAttribPointer(shader->texcoord_attrib, 2, GL_FLOAT, GL_FALSE, sizeof(vertex_data), (void*)(sizeof(GLfloat) * 2));
		}
		if (shader->color_attrib != -1) {
			glEnableVertexAttribArray(shader->color_attrib);
			glVertexAttribPointer(shader->color_attrib, 4, GL_FLOAT, GL_FALSE, sizeof(vertex_data), (void*)(sizeof(GLfloat) * 4));
		}

		glDrawArrays(vr->kind, 0, vx->nb);

		glDisableVertexAttribArray(shader->vertex_attrib);
		glDisableVertexAttribArray(shader->texcoord_attrib);
		glDisableVertexAttribArray(shader->color_attrib);
		glBindBuffer(GL_ARRAY_BUFFER, 0);

	// Fallback OpenGl 1.1 way, no shaders, fixed pipeline
	} else {
		glVertexPointer(2, GL_FLOAT, sizeof(vertex_data), vx->vertices);
		glTexCoordPointer(2, GL_FLOAT, sizeof(vertex_data), &vx->vertices[0].u);
		glColorPointer(4, GL_FLOAT, sizeof(vertex_data), &vx->vertices[0].r);
		glDrawArrays(vr->kind, 0, vx->nb);
	}

	glTranslatef(-x, -y, 0);
	vx->changed = FALSE;
}
/*
RendererState::RendererState(int w, int h) {
	view = glm::ortho(0.f, (float)w, (float)h, 0.f, -1001.f, 1001.f);
	world = glm::mat4();
}

void RendererState::translate(float x, float y, float z) {
	glm::mat4 t = glm::translate(glm::mat4(), glm::vec3(x, y, z));
	world *= t;
}

void renderer_init(int w, int h) {
	state = new RendererState(w, h);
}
*/