#include <CGAL/Three/Polyhedron_demo_plugin_interface.h>
#include <QApplication>
#include <QObject>
#include <QAction>
#include <QMainWindow>
#include <QInputDialog>
#include "Messages_interface.h"
#include "CGAL/Three/Scene_group_item.h"
#include "Scene_plane_item.h"

//This plugin crates an action in Operations that displays "Hello World" in the 'console' dockwidet.
class BasicItemPlugin :
    public QObject,
    public CGAL::Three::Polyhedron_demo_plugin_interface
{
  Q_OBJECT
  Q_INTERFACES(CGAL::Three::Polyhedron_demo_plugin_interface)
  Q_PLUGIN_METADATA(IID "com.geometryfactory.PolyhedronDemo.PluginInterface/1.0")
public:
  //! [applicable]
  //This plugin is only applicable if there is at exactly one selected item.
  bool applicable(QAction*) const
  {
    return scene->selectionIndices().size() ==1;
  }
  //! [applicable]
  //the list of the actions of the plugin.
  QList<QAction*> actions() const
  {
    return _actions;
  }
  //this acts like a constructor for the plugin. It gets the references to the mainwindow and the scene, and connects the action.
  void init(QMainWindow* mainWindow, CGAL::Three::Scene_interface* sc  )
  {
    //get the references
    this->scene = sc;
    this->mw = mainWindow;

    //creates the action
    QAction *actionHelloWorld= new QAction(QString("Hello World"), mw);
    //specifies the subMenu
    actionHelloWorld->setProperty("submenuName", "Basic");
    //links the action
    if(actionHelloWorld) {
      connect(actionHelloWorld, SIGNAL(triggered()),
              this, SLOT(helloWorld()));
      _actions << actionHelloWorld;
    }
  }

  void init(QMainWindow* mw, CGAL::Three::Scene_interface* sc, Messages_interface* mi)
  {
    //gets the reference to the message interface, to display text in the console widget
    this->messageInterface = mi;
    init(mw, sc);
  }
private Q_SLOTS:


  void helloWorld()
  { //! [use]
    //get a reference to the selected item.
    CGAL::Three::Scene_item *item = scene->item(scene->mainSelectionIndex());
    messageInterface->information(QString("The selected item's name is  : %1").arg(item->name()));
    //! [use]
    //! [additem]
    //creates a plane item
    Scene_plane_item *new_item = new Scene_plane_item(scene);
    new_item->setName("Trivial Plane");
    new_item->setColor(Qt::blue);
    new_item->setNormal(0.0,0.0,1.0);
    scene->addItem(new_item);
    //! [additem]
    //! [group]
    //clears the selection to avoid adding unwanted items to the group.
    scene->setSelectedItem(-1);
    //Creates a new group
    Scene_group_item *group = new Scene_group_item("New group");
    //Then gives it its children
    scene->changeGroup(item, group);
    scene->changeGroup(new_item,group);
    //adds it to the scene
    scene->add_group(group);
    //! [group]
  }

private:
  QList<QAction*> _actions;
  Messages_interface* messageInterface;
  //The reference to the scene
  CGAL::Three::Scene_interface* scene;
  //The reference to the main window
  QMainWindow* mw;
};

#include "Basic_item_plugin.moc"
