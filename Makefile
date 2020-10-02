TARGET          := libopenal

SRC_OPENAL32	:=\
	OpenAL32/alAuxEffectSlot.c \
	OpenAL32/alBuffer.c \
	OpenAL32/alEffect.c \
	OpenAL32/alError.c \
	OpenAL32/alExtension.c \
	OpenAL32/alFilter.c \
	OpenAL32/alListener.c \
	OpenAL32/alSource.c \
	OpenAL32/alState.c \
	OpenAL32/event.c \
	OpenAL32/sample_cvt.c

SRC_ALC	:=\
	Alc/ALc.c \
	Alc/ALu.c \
	Alc/alconfig.c \
	Alc/bs2b.c \
	Alc/converter.c \
	Alc/mastering.c \
	Alc/ringbuffer.c \
	Alc/effects/autowah.c \
	Alc/effects/chorus.c \
	Alc/effects/compressor.c \
	Alc/effects/dedicated.c \
	Alc/effects/distortion.c \
	Alc/effects/echo.c \
	Alc/effects/equalizer.c \
	Alc/effects/fshifter.c \
	Alc/effects/modulator.c \
	Alc/effects/null.c \
	Alc/effects/pshifter.c \
	Alc/effects/reverb.c \
	Alc/filters/filter.c \
	Alc/filters/nfc.c \
	Alc/filters/splitter.c \
	Alc/helpers.c \
	Alc/hrtf.c \
	Alc/uhjfilter.c \
	Alc/ambdec.c \
	Alc/bformatdec.c \
	Alc/panning.c \
	Alc/mixvoice.c \
	Alc/mixer/mixer_c.c \
	Alc/mixer/mixer_neon.c

SRC_COMMON	:=\
	common/alcomplex.c \
	common/almalloc.c \
	common/atomic.c \
	common/rwlock.c \
	common/threads.c \
	common/uintmap.c

SRC_BACKENDS	:=\
	Alc/backends/base.c \
	Alc/backends/loopback.c \
	Alc/backends/null_backend.c \
	Alc/backends/sdl2.c

SOURCEFILES_C	:=\
	$(SRC_COMMON) \
	$(SRC_ALC) \
	$(SRC_OPENAL32) \
	$(SRC_BACKENDS)
	
OBJS     := $(SOURCEFILES_C:.c=.o) $(ASMFILES:.S=.o)

PREFIX  = arm-dolce-eabi
CC      = $(PREFIX)-gcc
AR      = $(PREFIX)-gcc-ar
CFLAGS  = -g -Wl,-q -O3 -ffast-math -mtune=cortex-a9 -mfpu=neon -ftree-vectorize \
	-Iinclude -Ivita -IOpenAL32/Include -IAlc -Icommon -DVITA \
	-DAL_LIBTYPE_STATIC -DAL_ALEXT_PROTOTYPES
	
ASFLAGS = $(CFLAGS)

all: $(TARGET).a

$(TARGET).a: $(OBJS)
	$(AR) -rc $@ $^
	
clean:
	@rm -rf $(TARGET).a $(TARGET).elf $(OBJS)
	
install: $(TARGET).a
	@mkdir -p $(DOLCESDK)/$(PREFIX)/lib/
	cp $(TARGET).a $(DOLCESDK)/$(PREFIX)/lib/
	@mkdir -p $(DOLCESDK)/$(PREFIX)/include/
	cp -a include/. $(DOLCESDK)/$(PREFIX)/include/
