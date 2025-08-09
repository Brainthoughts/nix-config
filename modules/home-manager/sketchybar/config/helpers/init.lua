-- Add the sketchybar module to the package cpath
package.cpath = package.cpath .. ";@sbarlua-path@/lib/lua/5.4/?.so"

os.execute("(cd helpers && make)")
