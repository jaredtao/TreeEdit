QT += testlib concurrent
QT -= gui

include(../../src/TaoJsonModel/TaoJsonModel.pri)
CONFIG += qt console warn_on depend_includepath testcase
CONFIG -= app_bundle

TEMPLATE = app
DESTDIR = $$PWD/../../bin
SOURCES +=  tst_loadtest.cpp
