MK = ./mk
VAMS= fact.vam fib.vam hello.vam simplest.vam test2.vam test.vam
VASS = fact.vas fib.vas hello.vas simplest.vas test2.vas test.vas

all : $(VAMS)

clean:
	rm -f $(VAMS) $(VASS)
#BUILT_SOURCES = fact.vam fact.vas fib.vam fib.vas hello.vam hello.vas simplest.vam simplest.vas test2.vam test2.vas test.vam test.vas
#CLEANFILES = $(BUILT_SOURCES)
#TOOLS = vc vsl

fact.vam: fact.vsl $(TOOLS)
	$(MK) $<

fib.vam: fib.vsl
	$(MK) $<

hello.vam: hello.vsl
	$(MK) $<

simplest.vam: simplest.vsl
	$(MK) $<

test2.vam: test2.vsl
	$(MK) $<

test.vam: test.vsl
	$(MK) $<
