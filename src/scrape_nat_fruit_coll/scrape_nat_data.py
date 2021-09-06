#!/usr/bin/env python3

# Max Brown; Wellcome Sanger Institute 2021

# irritatingly few identifiers in this website...

import os
import sys
import time
from selenium.webdriver import Chrome
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import NoSuchElementException

opts = Options()
browser = webdriver.Chrome(ChromeDriverManager().install())

with open("./nat_urls.txt", "r") as urls:
    for url in urls:
        browser.get(url)
        # the main text where all the info is
        main = browser.find_element_by_id("main-copy")
        print(main.text + "\nNEXT RECORD\n")
