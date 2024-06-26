project('wofi', 'c', version : 'git', default_options : ['c_std=c99', 'buildtype=release', 'warning_level=2'])
cc = meson.get_compiler('c')

pkgcfg = import('pkgconfig')

inc = include_directories('inc')
gtk = dependency('gtk+-3.0')
wayland = dependency('wayland-client')
threads = dependency('threads')
dl = cc.find_library('dl')

git = find_program('git', native : true, required : false)

version = meson.project_version()

if git.found()
	version = run_command(git, 'rev-parse HEAD', check : false).stdout().strip()
endif

add_project_arguments('-D_GNU_SOURCE', '-DVERSION="' + version + '"', language : 'c')
add_project_link_arguments('-rdynamic', language : 'c')

sources = ['src/config.c',
			'src/main.c',
			'src/map.c',
			'src/match.c',
			'src/property_box.c',
			'src/utils_g.c',
			'src/utils.c',
			'src/widget_builder.c',
			'src/wofi.c',
			'proto/wlr-layer-shell-unstable-v1-protocol.c',
			'proto/xdg-output-unstable-v1-protocol.c',
			'proto/xdg-shell-protocol.c']
			
deps = [gtk, wayland, dl, threads]
			
if get_option('enable_run')
	sources += 'modes/run.c'
endif

if get_option('enable_drun')
	sources += 'modes/drun.c'
	deps += dependency('gio-unix-2.0')
endif

if get_option('enable_dmenu')
	sources += 'modes/dmenu.c'
endif

install_man('man/wofi.1',
			'man/wofi.3',
			'man/wofi.5',
			'man/wofi.7',
			'man/wofi-api.3',
			'man/wofi-config.3',
			'man/wofi-keys.7',
			'man/wofi-map.3',
			'man/wofi-utils.3',
			'man/wofi-widget-builder.3')

subdir = 'wofi-1'

install_headers('inc/config.h',
				'inc/map.h',
				'inc/utils_g.h',
				'inc/utils.h',
				'inc/widget_builder_api.h',
				'inc/wofi_api.h',
				subdir : subdir)

pkgcfg.generate(name : meson.project_name(),
				description : 'Wofi API for developing modes',
				requires : wayland,
				subdirs : subdir)

executable(meson.project_name(), sources, include_directories : inc, dependencies : deps, install : true)
