
#ifndef GLOBAL_VARIABLES_FILE_H_
#define GLOBAL_VARIABLES_FILE_H_

#include "Neuron.h"
#include "CubeFactory.h"
#include "CloudFactory.h"
#include "GraphFactory.h"
#include "utils.h"
#include "Axis.h"
#include "Contour.h"
#include "GraphCut.h"

//Camera parameters
double fovy3D = 60;
double aspect3D = 1;
double zNear3D = 30;
double zFar3D = 1000;
double disp3DX = 0;
double disp3DY = 0;
double disp3DZ = 200;
double rot3DX = 0;
double rot3DY = 0;


//Canvas parameters
GtkWidget *ascEditor;
GtkWidget* drawing3D;
GtkWidget* contourEditor;
double widgetWidth = 0;
double widgetHeight = 0;

//Cube variables
Cube_P* cube;
int cubeColToDraw = 0;
int cubeRowToDraw = 0;
float layerToDrawXY = 0;
float layerToDrawXZ = 0;
float layerToDrawYZ = 0;

double wx, wy, wz;

//Neuron Variables
Neuron* neuronita = NULL;
NeuronPoint* last_point;
NeuronSegment* current_segment;



//Control of the editor in MOD_ASCEDITOR
/** Actions done on the points of the neuron|: (with last_point).
NPA_SELECT = select the last point
NPA_APPLY_RECURSIVE_OFFSET = from the point, move all the following points and the sons
             towards wherever
NPA_APPLY_RECURSIVE_OFFSET_CLOSEST_POINT_TO_CLICK = idem but from the closest point
             to the click
NPA_CHANGE_POINT_CLOSEST_TO_CLICK = moves the closest point to the mouse position
NPA_CHANGE_POINT = changes the selected point to the click

Actions done with the last segment (current_segment)
NSA_ADD_POINTS
NSA_ADD_DENDRITE
NSA_ADD_BRANCH
NSA_ERASE_POINT
NSA_ERASE_WHOLE_SEGMENT
NSA_ERASE_SEGMENT_FROM_HERE
 */
enum NeuronPointActions{
  NPA_SELECT,
  NPA_APPLY_RECURSIVE_OFFSET,
  NPA_APPLY_RECURSIVE_OFFSET_CLOSEST_POINT_TO_CLICK,
  NPA_CHANGE_POINT_CLOSEST_TO_CLICK,
  NPA_CHANGE_POINT,
  NSA_ADD_POINTS,
  NSA_ADD_DENDRITE,
  NSA_ADD_BRANCH,
  NSA_ERASE_POINT,
  NSA_ERASE_WHOLE_SEGMENT,
  NSA_ERASE_SEGMENT_FROM_HERE,
  NSA_CONTINUE_SEGMENT,
  NPA_NONE
};

int   ascEditor_action = 0;
float asc_point_width = 1.0;
bool  ascEditor2D = false;



/** According to the mode the key-bindings and the actions to take with the unprojected mouse position change.
Modes:
MOD_VIEWER ---- the mode per default.
MOD_ASCEDITOR - to edit asc files
*/
enum MayorMode { MOD_VIEWER,
                 MOD_ASCEDITOR,
                 MOD_CONTOUREDITOR};

int majorMode = MOD_VIEWER;

/** Globals related to MOD_VIEWER*/
bool flag_draw_3D = true;
bool flag_draw_XY = false;
bool flag_draw_XZ = false;
bool flag_draw_YZ = false;
bool flag_draw_combo = false;
bool flag_draw_neuron = true;
int layerSpanViewZ = 1;
bool drawCube_flag = true;
bool flag_minMax   = false;
bool flag_verbose = false;
bool flag_cube_transparency = false;


bool flag_save_neuron_coordinate = false;
bool flag_save_cube_coordinate   = false;



/** Globals related to the ui.*/
unsigned char mouse_buttons[3] = {0};
int mouse_last_x = 0;
int mouse_last_y = 0;
int mouse_current_x = 0;
int mouse_current_y = 0;

//Names of the stuff
string neuron_name = "";
string volume_name;


/** Objects that are there.*/
vector< string >    objectNames;
vector< VisibleE* > toDraw;
vector< Contour<Point>* > lContours;
vector< GraphCut<Point>* > lGraphCuts;

// Parameters
int argcp;
char ** argvp;

// Shaders
GLuint shader_v = 0; // vertex shader id
GLuint shader_f = 0; // fragment shader id
GLuint shader_p = 0; // program shader id

// Control of the contours editor

enum ContourPointActions{
  CPA_SELECT,
  CPA_ADD_POINTS,
  CPA_NONE
};

enum ContourPointType{
  CPT_SOURCE,
  CPT_SINK
};

enum ContourType{
  CT_SIMPLE_CONTOUR=0,
  CT_GRAPHCUT
};

ContourPointActions contourEditor_action = CPA_SELECT;

Contour<Point>* currentContour = 0;

GraphCut<Point>* currentGraphCut = 0;

#endif
