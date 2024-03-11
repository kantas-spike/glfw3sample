# SRCS specifies which files to compile as part of the project

SRC_PATH = .
OBJ_PATH = obj
BIN_PATH = bin

# Forcefully create required directories
REQUIRED_DIRS = $(SRC_PATH) $(OBJ_PATH) $(BIN_PATH)
_MKDIRS := $(shell for d in $(REQUIRED_DIRS); \
		do															\
			[[ -d $$d ]] || mkdir -p $$d; \
		done)

APP_NAME = main

SRCS = $(SRC_PATH)/*.cpp
OBJS = $(OBJ_PATH)/*.o
HEADERS = $(SRC_PATH)/*.h
APP_PATH = $(BIN_PATH)/$(APP_NAME)

SRC= $(wildcard $(SRCS))
# $(info SRC is $(SRC))
OBJ= $(subst $(SRC_PATH)/,$(OBJ_PATH)/,$(SRC:.cpp=.o))
# $(info OBJ is $(OBJ))


# CC specifies which compiler we're using
CC = g++
RM = rm

# INCLUDE_PATHS specifies the additional include paths we'll need
INCLUDE_PATHS = -I/usr/local/include -I/opt/X11/include

# LIBRARY_PATHS specifies the additional library paths we'll need
LIBRARY_PATHS = -L/usr/local/lib -I/opt/X11/lib

# COMPILER_FLAGS specifies the additional compilation options we're using
# -w suppresses all warnings
COMPILER_FLAGS = -w -std=c++11

ifeq ($(DEBUG),yes)
	COMPILER_FLAGS += -g
endif

# LINKER_FLAGS specifies the libraries we're linking against
# Cocoa, IOKit, and CoreVideo are needed for static GLFW3.
# The glfw3 is deprecated. Now when you run 'brew install glfw3' you actually installed the glfw with version 3.x
LINKER_FLAGS = -lglfw  -lGLEW -framework Cocoa -framework OpenGL -framework IOKit -framework CoreVideo


# APP_NAME specifies the name of our exectuable

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.cpp $(HEADERS)
	$(CC) -o $@ -c $< $(COMPILER_FLAGS)

#This is the target that compiles our executable
$(APP_NAME) : $(OBJ)
	$(CC) $(OBJ) $(INCLUDE_PATHS) $(LIBRARY_PATHS) $(COMPILER_FLAGS) $(LINKER_FLAGS) -o $(APP_PATH)

# clean all sources
clean:
	$(RM) -rf $(OBJS)
	$(RM) -rf $(SRC_PATH)/*o
	$(RM) -rf $(APP_PATH)
