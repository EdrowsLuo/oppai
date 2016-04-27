# ------------------------------------------------------------------------------
# Generic C++ Makefile
# 
# Version: 1.0
# Author: Franc[e]sco
# Description:
# Compiles all .cc, .s and .S files in SRCDIR to obj files in OBJDIR, then gets 
# rid of unused code.
# ------------------------------------------------------------------------------
TARGET = tpdiff

CXX = g++
CXXFLAGS = -std=c++14 -Wall -Werror -DSLIDERTEST

LINKER = g++ -o 
LFLAGS = -lGL -lglut

SRCDIR = .
OBJDIR = obj
BINDIR = .

SOURCES := $(wildcard $(SRCDIR)/*.cc)
SSOURCES := $(wildcard $(SRCDIR)/*.s)
USSOURCES := $(wildcard $(SRCDIR)/*.S) 

OBJECTS := $(SOURCES:$(SRCDIR)/%.cc=$(OBJDIR)/%.o)
SOBJECTS := $(SSOURCES:$(SRCDIR)/%.s=$(OBJDIR)/%.o)
USOBJECTS := $(USSOURCES:$(SRCDIR)/%.S=$(OBJDIR)/%.o)

$(BINDIR)/$(TARGET): dirs $(OBJECTS) $(SOBJECTS) $(USOBJECTS)
	@echo "Linking..."
	@$(LINKER) $@ $(OBJECTS) $(SOBJECTS) $(USOBJECTS) $(LFLAGS)
	@echo "Stripping..."
	@strip -R .comment $@

$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.cc
	@echo "Compiling "$<"..."
	@$(CXX) $(CXXFLAGS) -c $< -o $@

$(SOBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.s
	@echo "Compiling ASM "$<"..."
	@$(CXX) $(CXXFLAGS) -c $< -o $@

$(USOBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.S
	@echo "Compiling ASM "$<" (with preprocessor)..."
	@$(CXX) $(CXXFLAGS) -c $< -o $@

dirs:
	@mkdir -p $(OBJDIR)
	@mkdir -p $(BINDIR)

.PHONEY: clean
clean:
	@echo "Cleaning..."
	rm -f $(OBJECTS)
	rm -f $(SOBJECTS)
	rm -f $(USOBJECTS)
	rm -f $(BINDIR)/$(TARGET)