clear all

M = AmazingModel();
G = AmazingGUI();
C = AmazingController(G, M);

C.register_callbacks();

C.gui.fig.Visible = 'on'