/*
    TE4 - T-Engine 4
    Copyright (C) 2009, 2010 Nicolas Casalini

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

#include <stdio.h>
#include <stdlib.h>

#ifdef SELFEXE_WINDOWS
#include <windows.h>
#else
#include <dlfcn.h>
#endif

#include "physfs.h"

// Load the shared lib containing the core and calls te4main inside it, passing control to that core
int run_core(int corenum, int argc, char **argv)
{
	int (*te4main)(int, char**);

	/***********************************************************************
	 ** Windows DLL loading code
	 ***********************************************************************/
#ifdef SELFEXE_WINDOWS

	HINSTANCE handle = LoadLibrary("game/engines/cores/te4core-12.dll");
	if (!handle) {
		fprintf(stderr, "Error loading core %d: %d\n", corenum, GetLastError());
		exit(EXIT_FAILURE);
	}

	te4main = GetProcAddress(handle, "te4main");
	if (te4main == NULL)  {
		fprintf(stderr, "Error binding to core %d: %d\n", corenum, GetLastError());
		exit(EXIT_FAILURE);
	}

	// Run the core
	corenum = te4main(argc, argv);

	FreeLibrary(handle);

	/***********************************************************************
	 ** POSIX so loading code
	 ***********************************************************************/
#else
	char *error;

	void *handle = dlopen("game/engines/cores/te4core-12.so", RTLD_LAZY);
	if (!handle) {
		fprintf(stderr, "Error loading core %d: %s\n", corenum, dlerror());
		exit(EXIT_FAILURE);
	}

	dlerror();    /* Clear any existing error */

	/* Writing: cosine = (double (*)(double)) dlsym(handle, "cos");
	 would seem more natural, but the C99 standard leaves
	 casting from "void *" to a function pointer undefined.
	 The assignment used below is the POSIX.1-2003 (Technical
	 Corrigendum 1) workaround; see the Rationale for the
	 POSIX specification of dlsym(). */

	*(void **) (&te4main) = dlsym(handle, "te4main");

	if ((error = dlerror()) != NULL)  {
		fprintf(stderr, "Error binding to core %d: %s\n", corenum, error);
		exit(EXIT_FAILURE);
	}

	// Run the core
	corenum = te4main(argc, argv);

	dlclose(handle);
#endif

	return corenum;
}

// Let some platforms use a different entry point
#ifdef USE_TENGINE_MAIN
#ifdef main
#undef main
#endif
#define main tengine_main
#endif

int main(int argc, char **argv)
{
	int core = 12;

	/***************** Physfs Init *****************/
	PHYSFS_init(argv[0]);

	const char *selfexe = get_self_executable(argc, argv);
	if (selfexe)
	{
		PHYSFS_mount(selfexe, "/", 1);
	}
	else
	{
		printf("NO SELFEXE: bootstrapping from CWD\n");
		PHYSFS_mount("bootstrap", "/bootstrap", 1);
	}

	PHYSFS_deinit();

	// Run the requested cores until we want no more
	while (core) core = run_core(core, argc, argv);

	exit(EXIT_SUCCESS);
}
