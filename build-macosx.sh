#!/bin/sh

#
# FOR $HOST_NUM_CPUS
#
. `dirname $0`/build-common.sh

BOOST_DIR="boost"

if [ ! -d $BOOST_DIR ]; then
  echo "ERROR: boost DIRECTORY NOT FOUND"
  echo "DID YOU EXECUTE init.sh?"
  exit 1
fi

cd $BOOST_DIR

rm bjam
rm b2
rm project-config.jam
rm -rf bin.v2

./bootstrap.sh 2>&1

if [ $? != 0 ]; then
  echo "ERROR: boostrap FAILED"
  exit 1
fi

cat ../configs/macosx.jam >> project-config.jam

# ---

LIBRARIES="--with-system --with-filesystem --with-iostreams"

STAGE_DIR="stage/macosx"

# ---

rm -rf $STAGE_DIR

./b2 -q -j${HOST_NUM_CPUS}   \
toolset=clang-osx            \
link=static                  \
variant=release              \
$LIBRARIES                   \
stage                        \
--stagedir=$STAGE_DIR        \

# ---

echo "\nDONE! BUILT LIBS ARE IN ${BOOST_DIR}/${STAGE_DIR}/lib"
