class ColorMatrix extends Matrix {
  int[][] _myCellColor;
  int bkg = 0x00000000;

  ColorMatrix(ControlP5 cp5, String theName) {
    super(cp5, theName);

    setView(new ControllerView() {
      void display(PApplet p, Object b) {
        p.noStroke();
        p.fill(bkg);
        p.rect(0, 0, width, height);
        for (int x = 0; x < _myCellX; x++) {
          for (int y = 0; y < _myCellY; y++) {
            if (_myCells[x][y] == 1) {
              p.fill(_myCellColor[x][y]);
              p.rect(x * stepX, y * stepY, stepX - gapX, stepY - gapY);
            } else {
              p.fill(bkg);
              p.rect(x * stepX, y * stepY, stepX - gapX, stepY - gapY);
            }
          }
        }
        if (isInside()) {
          int x = (int) ((p.mouseX - position.x) / stepX);
          int y = (int) ((p.mouseY - position.y) / stepY);
          if (x >= 0 && x < _myCellX && y >= 0 && y < _myCellY) {
            p.fill(_myCells[x][y] == 1 ? -0.2 : -0.5);
            p.rect(x * stepX, y * stepY, stepX - gapX, stepY - gapY);
          }
        }
        p.fill(-1);
        p.rect(cnt * stepX, 0, 1, height - gapY);
      }
    }
    );
  }	

  ColorMatrix setGrid(int theCellX, int theCellY) {
    _myCellX = theCellX;
    _myCellY = theCellY;
    sum = _myCellX * _myCellY;
    stepX = width / _myCellX;
    stepY = height / _myCellY;
    _myCells = new int[_myCellX][_myCellY];
    _myCellColor = new int[_myCellX][_myCellY];
    for (int x = 0; x < _myCellX; x++) {
      for (int y = 0; y < _myCellY; y++) {
        _myCells[x][y] = 1;
        _myCellColor[x][y] = 0;
      }
    }
    return this;
  }

  void updatecnt(int column) {
    cnt = column;
  }

  ColorMatrix setBackground(int c) {
    bkg = 0x00000000;
    if ((c >> 24 & 0xff) > 0) {
      bkg = (c >> 24) << 24 | (c >> 16) << 16 | (c >> 8) << 8 | (c >> 0) << 0;
    }
    return this;
  }

  ColorMatrix setCellColor(int theX, int theY, int theValue) {
    _myCellColor[theX][theY] = theValue;
    return this;
  }

  int getCellColor(int theX, int theY) {
    return _myCellColor[theX][theY];
  }

  ColorMatrix clear() {
    for (int x = 0; x < _myCells.length; x++) {
      for (int y = 0; y < _myCells[x].length; y++) {
        _myCells[x][y] = 1;
        _myCellColor[x][y] = 0;
      }
    }
    return this;
  }
}

