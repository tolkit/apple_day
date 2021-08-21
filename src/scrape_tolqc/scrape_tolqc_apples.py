#!/usr/bin/env python3

# Max Brown; Wellcome Sanger Institute 2021

# get all the apple data from tolqc (make an api guys! ;))

import os
import sys
import time
from selenium.webdriver import Chrome
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import ElementNotInteractableException


if len(sys.argv) != 3:
    print("Usage: python3 scrape_tolqc_apples.py <apple_name> <out_dir>")
    sys.exit(1)

apple_name = sys.argv[1]
out_dir = sys.argv[2]

opts = Options()
browser = webdriver.Chrome(ChromeDriverManager().install())

# see if an element exists
def check_exists_by_xpath(xpath):
    try:
        browser.find_element_by_xpath(xpath)
    except NoSuchElementException:
        return False
    return True


# or if an element is interactable
def check_interactable_by_xpath(xpath):
    try:
        browser.find_element_by_xpath(xpath).click()
    except ElementNotInteractableException:
        return False
    return True


browser.get(f"https://tolqc.cog.sanger.ac.uk/darwin/dicots/{apple_name}/")

main_table = []
# headers
main_table.append("source\tspecimen\tkmer\thaploid\trepeat\thet")

# get the genomescope table
gscope_table = browser.find_element_by_id("gscope_table")
gscope_tbody = gscope_table.find_element_by_tag_name("tbody")
gscope_tbody_rows = browser.execute_script(
    "return document.getElementById('gscope_table').getElementsByTagName('tr').length"
)

for tr_no in range(1, gscope_tbody_rows):

    source = gscope_tbody.find_element_by_xpath(
        "/html/body/div[2]/div[3]/div[1]/div[2]/div[2]/table/tbody/tr["
        + str(tr_no)
        + "]/td[1]"
    ).text

    specimen = gscope_tbody.find_element_by_xpath(
        "/html/body/div[2]/div[3]/div[1]/div[2]/div[2]/table/tbody/tr["
        + str(tr_no)
        + "]/td[2]"
    ).text

    kmer = gscope_tbody.find_element_by_xpath(
        "/html/body/div[2]/div[3]/div[1]/div[2]/div[2]/table/tbody/tr["
        + str(tr_no)
        + "]/td[3]"
    ).text

    haploid = gscope_tbody.find_element_by_xpath(
        "/html/body/div[2]/div[3]/div[1]/div[2]/div[2]/table/tbody/tr["
        + str(tr_no)
        + "]/td[5]"
    ).text.replace(",", "")

    repeat = gscope_tbody.find_element_by_xpath(
        "/html/body/div[2]/div[3]/div[1]/div[2]/div[2]/table/tbody/tr["
        + str(tr_no)
        + "]/td[6]"
    ).text
    het = gscope_tbody.find_element_by_xpath(
        "/html/body/div[2]/div[3]/div[1]/div[2]/div[2]/table/tbody/tr["
        + str(tr_no)
        + "]/td[7]"
    ).text

    main_table.append(
        source
        + "\t"
        + specimen
        + "\t"
        + kmer
        + "\t"
        + haploid
        + "\t"
        + repeat
        + "\t"
        + het
    )
    print(specimen + " gscope table processed.")


ill_table = []
# headers
ill_table.append("source\tspecimen\tid\tread_pairs\tyield")

if check_interactable_by_xpath(
    "/html/body/div[2]/div[7]/div[1]/div[3]/div[2]/ul/li[2]/a"
):
    # start on second page (first is back)
    pg = 1
    while pg < 5:
        pg += 1
        try:
            browser.find_element_by_xpath(
                "/html/body/div[2]/div[7]/div[1]/div[3]/div[2]/ul/li[" + str(pg) + "]/a"
            ).click()

            # get the illumina table
            illumina_table = browser.find_element_by_id("illumina_table")
            illumina_tbody = illumina_table.find_element_by_tag_name("tbody")
            illumina_tbody_rows = browser.execute_script(
                "return document.getElementById('illumina_table').getElementsByTagName('tr').length"
            )
            for tr_no in range(1, illumina_tbody_rows):
                # specimen, read pairs & yield
                ill_specimen = illumina_tbody.find_element_by_xpath(
                    "/html/body/div[2]/div[7]/div[1]/div[2]/div[2]/table/tbody/tr["
                    + str(tr_no)
                    + "]/td[2]"
                ).text

                ill_run_id = illumina_tbody.find_element_by_xpath(
                    "/html/body/div[2]/div[7]/div[1]/div[2]/div[2]/table/tbody/tr["
                    + str(tr_no)
                    + "]/td[4]"
                ).text

                ill_read_pairs = illumina_tbody.find_element_by_xpath(
                    "/html/body/div[2]/div[7]/div[1]/div[2]/div[2]/table/tbody/tr["
                    + str(tr_no)
                    + "]/td[5]"
                ).text.replace(",", "")

                ill_yield = illumina_tbody.find_element_by_xpath(
                    "/html/body/div[2]/div[7]/div[1]/div[2]/div[2]/table/tbody/tr["
                    + str(tr_no)
                    + "]/td[6]"
                ).text.replace(",", "")

                ill_table.append(
                    "illumina"
                    + "\t"
                    + ill_specimen
                    + "\t"
                    + ill_run_id
                    + "\t"
                    + ill_read_pairs
                    + "\t"
                    + ill_yield
                )
                print(ill_specimen + " illumina table processed.")

        except NoSuchElementException:
            break
else:
    # get the illumina table
    illumina_table = browser.find_element_by_id("illumina_table")
    illumina_tbody = illumina_table.find_element_by_tag_name("tbody")
    illumina_tbody_rows = browser.execute_script(
        "return document.getElementById('illumina_table').getElementsByTagName('tr').length"
    )
    for tr_no in range(1, illumina_tbody_rows):
        # specimen, read pairs & yield
        ill_specimen = illumina_tbody.find_element_by_xpath(
            "/html/body/div[2]/div[7]/div[1]/div[2]/div[2]/table/tbody/tr["
            + str(tr_no)
            + "]/td[2]"
        ).text

        ill_run_id = illumina_tbody.find_element_by_xpath(
            "/html/body/div[2]/div[7]/div[1]/div[2]/div[2]/table/tbody/tr["
            + str(tr_no)
            + "]/td[4]"
        ).text

        ill_read_pairs = illumina_tbody.find_element_by_xpath(
            "/html/body/div[2]/div[7]/div[1]/div[2]/div[2]/table/tbody/tr["
            + str(tr_no)
            + "]/td[5]"
        ).text.replace(",", "")

        ill_yield = illumina_tbody.find_element_by_xpath(
            "/html/body/div[2]/div[7]/div[1]/div[2]/div[2]/table/tbody/tr["
            + str(tr_no)
            + "]/td[6]"
        ).text.replace(",", "")

        ill_table.append(
            "illumina"
            + "\t"
            + ill_specimen
            + "\t"
            + ill_run_id
            + "\t"
            + ill_read_pairs
            + "\t"
            + ill_yield
        )
        print(ill_specimen + " illumina table processed.")

# get the pacbio data

pbio_table = []
# headers
pbio_table.append("source\tspecimen\tid\tyield\tn50")

# check if it contains a second row...
if check_exists_by_xpath(
    "/html/body/div[2]/div[5]/div[1]/div[2]/div[2]/table/tbody/tr[1]/td[7]"
):
    # get the pacbio table
    pacbio_table = browser.find_element_by_id("pacbio_table")
    pacbio_tbody = pacbio_table.find_element_by_tag_name("tbody")
    pacbio_tbody_rows = browser.execute_script(
        "return document.getElementById('pacbio_table').getElementsByTagName('tr').length"
    )

    for tr_no in range(1, pacbio_tbody_rows):

        pbio_specimen = pacbio_tbody.find_element_by_xpath(
            "/html/body/div[2]/div[5]/div[1]/div[2]/div[2]/table/tbody/tr["
            + str(tr_no)
            + "]/td[1]"
        ).text

        pbio_run_id = pacbio_tbody.find_element_by_xpath(
            "/html/body/div[2]/div[5]/div[1]/div[2]/div[2]/table/tbody/tr["
            + str(tr_no)
            + "]/td[3]"
        ).text

        pbio_yield = pacbio_tbody.find_element_by_xpath(
            "/html/body/div[2]/div[5]/div[1]/div[2]/div[2]/table/tbody/tr["
            + str(tr_no)
            + "]/td[7]"
        ).text.replace(",", "")

        pbio_n50 = pacbio_tbody.find_element_by_xpath(
            "/html/body/div[2]/div[5]/div[1]/div[2]/div[2]/table/tbody/tr["
            + str(tr_no)
            + "]/td[8]"
        ).text.replace(",", "")

        pbio_table.append(
            "pacbio"
            + "\t"
            + pbio_specimen
            + "\t"
            + pbio_run_id
            + "\t"
            + pbio_yield
            + "\t"
            + pbio_n50
        )
        print(pbio_specimen + " pacbio table processed.")

# get the assemblies

asm_table = []
# headers
asm_table.append("specimen\tasm\tncontig50\tcontigs\tlength\tBUSCO")

# check if it contains a second row...
if check_exists_by_xpath(
    "/html/body/div[2]/div[9]/div[1]/div[2]/div[2]/table/tbody/tr[1]/td[2]"
):
    # get the asm table
    assembly_table = browser.find_element_by_id("asm_table")
    assembly_tbody = assembly_table.find_element_by_tag_name("tbody")
    assembly_tbody_rows = browser.execute_script(
        "return document.getElementById('asm_table').getElementsByTagName('tr').length"
    )

    for tr_no in range(1, assembly_tbody_rows):

        asm_specimen = assembly_tbody.find_element_by_xpath(
            "/html/body/div[2]/div[9]/div[1]/div[2]/div[2]/table/tbody/tr["
            + str(tr_no)
            + "]/td[1]"
        ).text

        asm_asm = assembly_tbody.find_element_by_xpath(
            "/html/body/div[2]/div[9]/div[1]/div[2]/div[2]/table/tbody/tr["
            + str(tr_no)
            + "]/td[2]"
        ).text

        asm_contign50 = assembly_tbody.find_element_by_xpath(
            "/html/body/div[2]/div[9]/div[1]/div[2]/div[2]/table/tbody/tr["
            + str(tr_no)
            + "]/td[4]"
        ).text.replace(",", "")

        asm_contigs = assembly_tbody.find_element_by_xpath(
            "/html/body/div[2]/div[9]/div[1]/div[2]/div[2]/table/tbody/tr["
            + str(tr_no)
            + "]/td[5]"
        ).text.replace(",", "")

        asm_length = assembly_tbody.find_element_by_xpath(
            "/html/body/div[2]/div[9]/div[1]/div[2]/div[2]/table/tbody/tr["
            + str(tr_no)
            + "]/td[8]"
        ).text.replace(",", "")

        asm_BUSCO = assembly_tbody.find_element_by_xpath(
            "/html/body/div[2]/div[9]/div[1]/div[2]/div[2]/table/tbody/tr["
            + str(tr_no)
            + "]/td[9]"
        ).text

        asm_table.append(
            asm_specimen
            + "\t"
            + asm_asm
            + "\t"
            + asm_contign50
            + "\t"
            + asm_contigs
            + "\t"
            + asm_length
            + "\t"
            + asm_BUSCO
        )
        print(asm_specimen + " asm table processed.")


# write a data files
print("Writing files...")

with open("%s/%s_gscope_data.txt" % (out_dir, apple_name), "w") as data_file:
    for row in main_table:
        data_file.write(row + "\n")

with open("%s/%s_ill_data.txt" % (out_dir, apple_name), "w") as data_file:
    for row in ill_table:
        data_file.write(row + "\n")

with open("%s/%s_pbio_data.txt" % (out_dir, apple_name), "w") as data_file:
    for row in pbio_table:
        data_file.write(row + "\n")

with open("%s/%s_asm_data.txt" % (out_dir, apple_name), "w") as data_file:
    for row in asm_table:
        data_file.write(row + "\n")

print(f"{apple_name} done!")
