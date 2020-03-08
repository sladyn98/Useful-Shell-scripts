## Remove empty directories under the specified dir (or current dir)
[ "`uname`" != Darwin ] && VERBOSE=-v
root=.
[ -n "$*" ] && root="$*"
find "$root" -depth -type d ! -name '.' ! -path "*.lrdata/*" -empty -exec rmdir $VERBOSE "{}" \;