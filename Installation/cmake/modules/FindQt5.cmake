#======================================================FindQt5.cmake=====================================================
#
#
#	This file has on purpose to search and include Qt5 modules wanted by the user.
#
#	To make this findQt5.cmake compatible with the Qt4 find_package, we use the QT_USE_QT* flags.
#
#	However, if the used does not set the flag QT_USE_QTCORE, this one is automatically set when findQt5 called.
#
#	NOTICE : Some part of this file are porting from findQt4.cmake by Kitware, Inc.
#
#==========================================================Success========================================================
#
#	If all modules asked by the user are found, so the flags QT5 and QT5_FOUND are set to TRUE.
#
#
#==========================================================Failure========================================================
#
#
#	If all modules asked by the flags are not found, findQt5 fails and returns the list of modules missing.
#
#   The flags QT5 and QT5_FOUND are not set.
#
#
#========================================================Typical use=======================================================
#
# 	Typical use could be : 
#
#		set( QT_USE_QTXML    TRUE )
#		set( QT_USE_QTSCRIPT  TRUE )
#		set( QT_USE_QTOPENGL  TRUE )
#
#
#		find_package(CGAL REQUIRED COMPONENTS Qt5) //Because we want to know the CGAL path to use findQt4or5
#
#		include(${CGAL_USE_FILE})// Same
#	
#		find_package(Qt5)// Here, we search and include all the modules previously set by the QT_USE_QT* flags.	
#
#		IF(QT5_FOUND)
#
#			qt5_wrap_cpp(cpp file.cpp)
#			qt5_wrap_ui (ui  fileui.ui )
#			qt5_add_ressource ( RESOURCE_FILES filescr.qrc )
#			qt5_generate_moc ( file.h file_moc.cpp)
#
#       	IF(QT5)
#				add_library(example
#				file.cpp
#				file_moc.cpp
#				)
#			ENDIF(QT5)
#		ENDIF(QT5_FOUND)
#
#
#	NORICE : this way is to does not use the AUTOMOC.
#
#================================================FindQt4.cmake compatibility==============================================
#
#	The QT_USE_QT* flags supported byb findQt5 are the followings :
#
#                    QT_USE_QTCORE
#                    QT_USE_QTD-BUS
#                    QT_USE_QTDECLARATIVE
#                    QT_USE_QTDESIGNER
#                    QT_USE_QTGRAPHICAL_EFFECTS
#                    QT_USE_QTGUI
#                    QT_USE_QTIMAGEFORMATS
#                    QT_USE_QTHELP
#                    QT_USE_QTMACEXTRATS
#                    QT_USE_QTMULTIMEDIA
#                    QT_USE_QTNETWORK
#                    QT_USE_QTNFC
#                    QT_USE_QTOPENGL
#                    QT_USE_QTPOSITIONING
#                    QT_USE_QTPRINTSUPPORT
#                    QT_USE_QTQML
#                    QT_USE_QTQUICK
#                    QT_USE_QTSCRIPT
#                    QT_USE_QTSENSORS
#                    QT_USE_QTSERIALPORT
#                    QT_USE_QTSQL
#                    QT_USE_QTSVG
#                    QT_USE_QTTEST
#                    QT_USE_QTUITOOLS
#                    QT_USE_QTWEBKIT
#                    QT_USE_QTWIDGETS
#                    QT_USE_QTWEBSOCKEETS
#                    QT_USE_QTWINDOWSEXTRAS
#                    QT_USE_QTX11EXTRAS
#                    QT_USE_QTXML
#                    QT_USE_QTXMLPATTERNS
#
#
#======================================================WIN_SDK_PATH=====================================================
#
#	This is the PATH to the Windows SDK that Qt5 needs to know.
#
#	The path is automatically set if contains into CMake Configuration files of CGAL. Otherwise, the user has to inform 
# the path into CMake-gui. 
#
#	For instance, on Windows 8 64 bits, the path is : C:/Program Files (x86)/Windows Kits/8.1/Lib/winv6.3/um/x64
#
#  NOTICE : Finally, it seems that this part is not necessary.
#
#
#


MESSAGE("Searching Qt5 modules.")


#	This one is maybe not necessary...

if(WIN32)

	SET (WIN_SDK_PATH ${WIN_SDK_PATH})

	if ( NOT WIN_SDK_PATH )
		MESSAGE("Qt5 on Windows needs Windows SDK.")
	
		FIND_PATH ( WIN_SDK_PATH WIN_SDK_PATH)
	endif()
	
	SET(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} ${WIN_SDK_PATH})

	MESSAGE( STATUS "Windows SDK path : ${WIN_SDK_PATH}")
endif()

UNSET(QT5 CACHE)
UNSET(QT5_FOUND CACHE)
UNSET(QT_VERSION_USED CACHE)

#We say that we want the version 5 of Qt library.
set(QT_VERSION_USED 5)

SET(QT_MODULES_MISSING "none")

  IF(NOT QT_USE_QTCORE)
    SET( QT_USE_QTCORE TRUE )
  ENDIF(NOT QT_USE_QTCORE)

# Qt modules
FOREACH(module Core GUI OpenGL Multimedia  
		Network QML Quick SQL Test WebKit 
		Widgets D-Bus Graphical_Effects ImageFormats 
		MacExtras NFC Positioning PrintSupport Declarative 
		Script Sensors SerialPort SVG WebSockets WindowsExtras
		X11Extras Xml XMLPatterns Designer Help UITools)

  STRING(TOUPPER ${module} component)

  IF (QT_USE_QT${component})
    	FIND_PACKAGE(Qt5${module} QUIET)
    	IF (Qt5${module}_FOUND)
      		message(STATUS "Qt5${module} found.")
      		SET(QT_INCLUDE_DIR ${QT_INCLUDE_DIR} ${Qt5${module}_INCLUDE_DIRS})
      		SET(QT_LIBRARIES ${QT_LIBRARIES} ${Qt5${module}_LIBRARIES})
      		SET(QT_DEFINITIONS ${QT_DEFINITIONS} ${Qt5${module}_DEFINITIONS})
    	ELSE (Qt5${module}_FOUND)
		if(QT_MODULES_MISSING STREQUAL "none")
			SET(QT_MODULES_MISSING "")
		endif()
      		SET(QT_MODULES_MISSING "${QT_MODULES_MISSING}, ${module}")
    	ENDIF (Qt5${module}_FOUND)
  ENDIF (QT_USE_QT${component})
  
ENDFOREACH(module)

  #######################################
  #
  #       Check the executables of Qt 
  #          ( moc, uic, rcc )
  #         Same as Qt4 version  
  #
  #######################################


  IF(QT_QMAKE_CHANGED)
    SET(QT_UIC_EXECUTABLE NOTFOUND)
    SET(QT_MOC_EXECUTABLE NOTFOUND)
    SET(QT_UIC3_EXECUTABLE NOTFOUND)
    SET(QT_RCC_EXECUTABLE NOTFOUND)
    SET(QT_DBUSCPP2XML_EXECUTABLE NOTFOUND)
    SET(QT_DBUSXML2CPP_EXECUTABLE NOTFOUND)
    SET(QT_LUPDATE_EXECUTABLE NOTFOUND)
    SET(QT_LRELEASE_EXECUTABLE NOTFOUND)
    SET(QT_QCOLLECTIONGENERATOR_EXECUTABLE NOTFOUND)
    SET(QT_DESIGNER_EXECUTABLE NOTFOUND)
    SET(QT_LINGUIST_EXECUTABLE NOTFOUND)
  ENDIF(QT_QMAKE_CHANGED)
  
  FIND_PROGRAM(QT_MOC_EXECUTABLE
    NAMES moc-qt5 moc
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_UIC_EXECUTABLE
    NAMES uic-qt5 uic
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_UIC3_EXECUTABLE
    NAMES uic3
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_RCC_EXECUTABLE 
    NAMES rcc
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_DBUSCPP2XML_EXECUTABLE 
    NAMES qdbuscpp2xml
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_DBUSXML2CPP_EXECUTABLE 
    NAMES qdbusxml2cpp
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_LUPDATE_EXECUTABLE
    NAMES lupdate-qt5 lupdate
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_LRELEASE_EXECUTABLE
    NAMES lrelease-qt5 lrelease
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_QCOLLECTIONGENERATOR_EXECUTABLE
    NAMES qcollectiongenerator-qt5 qcollectiongenerator
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_DESIGNER_EXECUTABLE
    NAMES designer-qt5 designer
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  FIND_PROGRAM(QT_LINGUIST_EXECUTABLE
    NAMES linguist-qt5 linguist
    PATHS ${QT_BINARY_DIR}
    NO_DEFAULT_PATH
    )

  IF (QT_MOC_EXECUTABLE)
     SET(QT_WRAP_CPP "YES")
  ENDIF (QT_MOC_EXECUTABLE)

  IF (QT_UIC_EXECUTABLE)
     SET(QT_WRAP_UI "YES")
  ENDIF (QT_UIC_EXECUTABLE)



  MARK_AS_ADVANCED( QT_UIC_EXECUTABLE QT_UIC3_EXECUTABLE QT_MOC_EXECUTABLE
    QT_RCC_EXECUTABLE QT_DBUSXML2CPP_EXECUTABLE QT_DBUSCPP2XML_EXECUTABLE
    QT_LUPDATE_EXECUTABLE QT_LRELEASE_EXECUTABLE QT_QCOLLECTIONGENERATOR_EXECUTABLE
    QT_DESIGNER_EXECUTABLE QT_LINGUIST_EXECUTABLE)


if(${QT_MODULES_MISSING} STREQUAL "none")
	set(QT5 TRUE)
	set(QT5_FOUND TRUE)

	set(CMAKE_AUTOMOC ON)
	set(CMAKE_INCLUDE_CURRENT_DIR ON)
else()
	message("Loading of Qt5 modules incomplete. Missing of ${QT_MODULES_MISSING} modules.")
endif()

message("End of searching Qt5 modules.")
