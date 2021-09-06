#!/usr/bin/env python3

# Max Brown; Wellcome Sanger Institute 2021

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

browser.get("http://www.nationalfruitcollection.org.uk/search(a-z).php")

# click to get to the search
browser.find_element_by_xpath(
    "/html/body/table/tbody/tr[3]/td[2]/form/p[3]/input"
).click()

# store the urls
urls = []

i = 0
while i < 21:
    elems = browser.find_elements_by_xpath("//a[@href]")
    for elem in elems:
        if (
            "http://www.nationalfruitcollection.org.uk/full2.php?varid="
            in elem.get_attribute("href")
        ):
            urls.append(elem.get_attribute("href"))
    try:
        browser.find_element_by_xpath(
            "/html/body/table/tbody/tr[3]/td[2]/form/dl/dd/input[4]"
        ).click()
    except NoSuchElementException:
        break
    i += 1

for url in urls:
    print(url)
