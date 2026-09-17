#include "../libgraph/libgraph.h"
#include "../libkeyb/libkeyb.h"
#include "invaders.h"

#define WIDTH   640
#define HEIGHT  264


static const Sprite sprites[][2][2] = {
  [ALIEN30] = {
    [ASCII] = {
      {
        {
          " {@@} ",
          " /\"\"\\ ",
          "      "
        }
      },
      {
        {
          " {@@} ",
          "  \\/  ",
          "      "
        }
      }
    },
    [UNICODE] = {
      {
        {
          "⢀⡴⣿⢦⡀ ",
          "⢈⢝⠭⡫⡁ ",
          "      "
        }
      },
      {
        {
          "⢀⡴⣿⢦⡀ ",
          "⠨⡋⠛⢙⠅ ",
          "      "
        }
      }
    }
  },
  [ALIEN20] = {
    [ASCII] = {
      {
        {
          " dOOb ",
          " ^/\\^ ",
          "      "
        }
      },
      {
        {
          " dOOb ",
          " ~||~ ",
          "      "
        }
      }
    },
    [UNICODE] = {
      {
        {
          "⢀⡵⣤⡴⣅ ",
          "⠏⢟⡛⣛⠏⠇",
          "      "
        }
      },
      {
        {
          "⣆⡵⣤⡴⣅⡆",
          "⢘⠟⠛⠛⢟⠀",
          "      "
        }
      }
    },
  },
  [ALIEN10] = {
    [ASCII] = {
      {
        {
          " /MM\\ ",
          " |~~| ",
          "      "
        }
      },
      {
        {
          " /MM\\ ",
          " \\~~/ ",
          "       "
        }
      }
    },
    [UNICODE] = {
      {
        {
          "⣴⡶⢿⡿⢶⣦",
          "⠩⣟⠫⠝⣻⠍",
          "      "
        }
      },
      {
        {
          "⣴⡶⢿⡿⢶⣦",
          "⣉⠽⠫⠝⠯⣉",
          "      "
        }
      }
    }
  },
  [MA] = {
    [ASCII] = {
      {
        {
          "_/MMM\\_",
          "qWAVAWp"
        }
      }
    },
    [UNICODE] = {
      {
        {
          "⢀⡴⣾⢿⡿⣷⢦⡀",
          "⠉⠻⠋⠙⠋⠙⠟⠉"
        }
      }
    }
  },
  [GUNNER] = {
    [ASCII] = {
      {
        {
          "  mAm  ",
          " MAZAM "
        }
      }
    },
    [UNICODE] = {
      {
        {
          " ⢀⣀⣾⣷⣀⡀ ",
          " ⣿⣿⣿⣿⣿⣿ "
        }
      }
    }
  },
  [GUNNER_EXPLODE] = {
    [ASCII] = {
      {
        {
          " ,' %  ",
          " ;&+,! "
        }
      },
      {
        {
          " -,+$! ",
          " +  ^~ "
        }
      }
    },
    [UNICODE] = {
      /* TODO */
      {
        {
          " ,' %  ",
          " ;&+,! "
        }
      },
      {
        {
          " -,+$! ",
          " +  ^~ "
        }
      }
    }
  },
  [ALIEN_EXPLODE] = {
    [ASCII] = {
      {
        {
          " \\||/ ",
          " /||\\ ",
          "       "
        }
      }
    },
    [UNICODE] = {
      /* TODO */
      {
        {
          " \\||/ ",
          " /||\\ ",
          "       "
        }
      }
    }
  },
  [SHELTER] = {
    [ASCII] = {
      {
        {
          "/MMMMM\\",
          "MMMMMMM",
          "MMM MMM"
        }
      }
    },
    [UNICODE] = {
      /* TODO */
      {
        {
          "/MMMMM\\",
          "MMMMMMM",
          "MMM MMM"
        }
      }
    }
  }
};

const char *alienBlank =  "      ";

const char *bombAnim =   "\\|/-";

static int ctype = ASCII;



void main()
{
    initKeyb();
    initGraph();
    clearScreen();


    printTop(1, "ASCII INVADERS");

    putText("                _ _   _                     _               ",(WIDTH / 2) - 240, 20, 7);
    putText("  __ _ ___  ___(_|_) (_)_ ____   ____ _  __| | ___ _ __ ___ ", (WIDTH / 2) - 240, 30, 7);
    putText(" / _` / __|/ __| | | | | '_ \\ \\ / / _` |/ _` |/ _ \\ '__/ __|", (WIDTH / 2) - 240, 40, 7);
    putText("| (_| \\__ \\ (__| | | | | | | \\ V / (_| | (_| |  __/ |  \\__ \\", (WIDTH / 2) - 240, 50, 7);
    putText(" \\__,_|___/\\___|_|_| |_|_| |_|\\_/ \\__,_|\\__,_|\\___|_|  |___/", (WIDTH / 2) - 240, 60, 7);

    unsigned y = 90;

    putText(sprites[MA][ctype][0].lines[0], (WIDTH / 2) - 90, y, 2);
    putText(sprites[MA][ctype][0].lines[1], (WIDTH / 2) - 90, y + 10, 2);
    putText("= ?  points", (WIDTH / 2), y + 5, 7);

    y += 30;

    putText(sprites[ALIEN30][ctype][0].lines[0], (WIDTH / 2) - 90, y, 7);
    putText(sprites[ALIEN30][ctype][0].lines[1], (WIDTH / 2) - 90, y + 10, 7);
    putText("= 30 points", (WIDTH / 2), y + 5, 7);

    y += 30;

    putText(sprites[ALIEN20][ctype][0].lines[0], (WIDTH / 2) - 90, y, 7);
    putText(sprites[ALIEN20][ctype][0].lines[1], (WIDTH / 2) - 90, y + 10, 7);
    putText("= 20 points", (WIDTH / 2), y + 5, 7);

    y += 30;

    putText(sprites[ALIEN10][ctype][0].lines[0], (WIDTH / 2) - 90, y, 7);
    putText(sprites[ALIEN10][ctype][0].lines[1], (WIDTH / 2) - 90, y + 10, 7);
    putText("= 10 points", (WIDTH / 2), y + 5, 7);

    waitAnyKey();
    printTop(1, "              ");

    finishGraph();    
    finishKeyb();    
}
