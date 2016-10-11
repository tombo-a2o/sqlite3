BUILD ?= build/debug
LIB = $(BUILD)/libsqlite3.a
CFLAGS = $(OPT_CFLAGS)
OBJS = $(BUILD)/sqlite3.o
HEADERS = sqlite3.h sqlite3ext.h
DEPS := $(OBJS:.o=.d)

all: $(LIB)

$(LIB): $(HEADERS) $(OBJS)
	rm -f $@
	emar rcs $@ $(OBJS)

clean:
	rm -f $(LIB) $(OBJS) $(DEPS)

-include $(DEPS)

$(BUILD)/%.o: %.c
	@mkdir -p $(@D)
	a2o $(CFLAGS) -MMD -MP -MF $(@:%.o=%.d) -o $@ $<

install: $(LIB) $(HEADERS)
	cp $(LIB) $(EMSCRIPTEN)/system/local/lib/
	cp $(HEADERS) $(EMSCRIPTEN)/system/local/include/

.PHONY: all clean install
