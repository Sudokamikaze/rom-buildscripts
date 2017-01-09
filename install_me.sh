
function main {
git clone https://github.com/Sudokamikaze/rom-buildscripts.git
mv rom-buildscripts/* ./
rm install_me.sh
rm -rf rom-buildscripts
}

function ifinstalled {
varforcheck=$(ls | grep "build_rom.sh")
if grep -q "build_rom.sh" $varforcheck then
echo "Already installed, scripts will updated"
unset varforcheck
fi
}


function ascii {
  echo -e "
          ------               _____
         /      \ ___\     ___/    ___
      --/-  ___  /    \/  /  /    /
     /     /           \__     //_
    /                     \   / ___     |
    |           ___       \/+--/        /
     \__           \       \           /
        \__                 |          /
       \     /____      /  /       |   /
        _____/         ___       \/  /
             \__      /      /    |    |
           /    \____/   \       /   //
       // / / // / /\    /-_-/\//-__-
        /  /  // /   \__// / / /  //
       //   / /   //   /  // / // /
        /// // / /   /  //  / //
  "
}

clear
ifinstalled
echo "Installing scripts"
ascii
main
