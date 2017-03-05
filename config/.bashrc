export SHARED_DIR='/src'
source "$SHARED_DIR/variables" &>/dev/null

# Make `racket` accessible
export PATH=$PATH:/src/racket-dist/bin/

# Make Spidermonkey accessible as `js`
ln -sf /usr/bin/js24 /usr/bin/js
