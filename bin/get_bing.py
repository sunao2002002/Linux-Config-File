#!/usr/bin/env python
#-*-coding: utf-8 -*-

import urllib, re, os
import logging

URL="http://cn.bing.com"
DEST="/root/bing/"
file_list = list()
def load_db():
    db_file =os.path.join(DEST, "file_list")
    if not os.path.exists(db_file):
        return
    lines = open(db_file).readlines()
    for line in lines:
        file_list.append(line.strip())
    logging.debug(file_list)

def write_db(item):
    db_file = os.path.join(DEST, "file_list")
    if not os.path.exists(DEST):
        os.makedirs(DEST)
    with open(db_file, "a+") as f:
        f.write(item)
        f.write("\r\n")


def save_img(imgurl):
    right = imgurl.rindex('/')
    name = imgurl[right+1:]
    if not imgurl.startswith("http"):
        imgurl = URL+imgurl
    save_path = os.path.join(DEST, name)
    if not os.path.exists(DEST):
        os.path.makedirs(DEST)
    urllib.urlretrieve(imgurl, save_path)

def get_bing_wallpaper():
    load_db()
    html = urllib.urlopen(URL).read()
    if not html:
        logging.error('open & read bing error')
        return -1
    logging.debug(html)
    reg = re.compile('<img id="bgImg" src="(.*?)"', re.S)
    imglist = re.findall(reg, html)
    logging.info(imglist)
    for imgurl in imglist:  
        if imgurl in file_list:
            logging.info(imgurl+"already in file_list")
            continue
        write_db(imgurl)
        save_img(imgurl)

if __name__ == '__main__':
    if not os.path.exists(DEST):
        os.makedirs(DEST)
    logfile = os.path.join(DEST, "log")
    logging.basicConfig(level=logging.INFO , format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
        filename=logfile,filemode="a")
    get_bing_wallpaper()
