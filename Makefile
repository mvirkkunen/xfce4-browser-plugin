PREFIX ?= /usr
PACKAGES = gmodule-2.0 gtk+-2.0 webkit-1.0 exo-1 libxfce4ui-1 libxfce4panel-1.0
#PACKAGES = gmodule-2.0 gtk+-3.0 webkit-1.0 exo-1 libxfce4ui-1 libxfce4panel-1.0

libdropdownbrowser.so: *.vala
	valac --vapidir ./xfce4-vala/vapi $(patsubst %,--pkg %, $(PACKAGES)) -C *.vala
	gcc -shared -fPIC $$(pkg-config --cflags --libs $(PACKAGES)) -o libdropdownbrowser.so *.c

clean:
	rm *.c
	rm *.so

xfce4-vala:
	git submodule init
	git submodule update

deps: xfce4-vala

install: all
	cp libdropdownbrowser.so $(PREFIX)/lib/xfce4/panel/plugins/
	cp dropdownbrowser.desktop $(PREFIX)/share/xfce4/panel/plugins/

uninstall:
	rm $(PREFIX)/lib/xfce4/panel/plugins/libdropdownbrowser.so
	rm $(PREFIX)/share/xfce4/panel/plugins/dropdownbrowser.desktop

restart:
	@echo "Restarting panel..."
	dbus-send --dest=org.xfce.Panel /org/xfce/Panel org.xfce.Panel.Terminate boolean:true

.PHONY: deps xfce4-vala clean uninstall restart

all: libdropdownbrowser.so dropdownbrowser.desktop
