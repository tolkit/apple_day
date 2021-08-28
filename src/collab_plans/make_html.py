#!/usr/bin/env python3

# hardcoded paths for now
with open("../../data/tolqc_data/json/all_apples_merged.json", "r") as file:
    all_apples_merged = file.read().replace("\n", "")
with open("../../data/tolqc_data/json/all_apples_merged_asm.json", "r") as file:
    all_apples_merged_asm = file.read().replace("\n", "")

# woow look at all those {{}}'s

html_string = """
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Apple Day!</title>
    <style>
        p,
        a,
        li,
        ul {{
            font-family: "garamond,serif";
            font-size: 17px;
        }}
        svg {{
            display: block;
            margin: auto;
        }}
        P,
        UL,
        OL {{
            width: 50%;
            margin: auto;
        }}
        h1,
        h2,
        h3 {{
            width: 50%;
            margin: auto;
            margin-bottom: 20px;
        }}
        p {{
            margin-bottom: 15px;
            margin-top: 10px;
        }}
        ul,
        ol {{
            margin-bottom: 10px;
            margin-top: 10px;
        }}
        a {{
            font-weight: bold;
            color: #a1d99b;
        }}
        select {{
            text-align-last: right;
            padding-right: 29px;
            direction: rtl;
            display: block;
            margin: 0 auto;
        }}
    </style>
</head>
<body>
    <h1>Apple Day sequencing</h1>
    <div>
        <p>Apple Day is approaching fast. The purpose of this document is to let all the collaborators know where we are
            at
            in
            terms of sequencing, and plans what is planned to do with the data we have generated.</p>
        <p>First of all, a big thank you to everyone who collected samples for Apple Day 2021! The data would not be
            here
            without you. I know that Maja and others have worked hard in the labs to get the DNA extracted. Currently,
            Marcela
            and Shane are building the apple assemblies, including the mitochondria and chloroplast. These will then be
            passed
            on to curation very soon. So, many thanks to these people!</p>
        <p>The resequencing data roster is pretty much complete, with some minor permission issues at Cambridge Botanic
            Garden
            that have now been resolved.</p>
    </div>
    <h2>Sequencing overview</h2>
    <div>
        <p>We have sequence data for <span id="stat1"></span> species (<i><span id="stat2"></span></i>) across <span
                id="stat3"></span> cultivars. Below shows the total sequencing effort. Hi-C, PacBio HiFi, and 10X data
            have been generated for the five reference genomes, whilst the resequencing consists of NovaSeq 150bp PE
            reads. <span id="stat4"></span> individuals of <i>Malus sylvestris</i> have been sequenced on illumina.</p>
    </div>
    <div id="plot1"></div>
    <div>
        <p>Using the data from <a href="https://tolqc.cog.sanger.ac.uk/">tolqc</a> we can look at the distribution of
            estimated
            genome sizes from the illumina resequencing data (there is some duplication of samples here):
        </p>
    </div>
    <div id="plot2"></div>
    <div>
        <p>And we can also use that same data source to see the distribution of estimated repeat content:</p>
    </div>
    <div id="plot3"></div>
    <div>
        <p>I have also made efforts to download a bunch of other data from two separate studies (Sun <i>et al</i>.,
            2020;
            Duan
            <i>et al</i>., 2017). A tabular format of the cultivars I\'ve downloaded the data for can be found <a
                href="https://github.com/tolkit/apple_day/blob/main/data/sra_metadata/sra_metadata.tsv">here</a>.
        </p>
    </div>
    <h2>Assembly overview</h2>
    <div>
        <p>Some preliminary asssemblies have been made. I\'ll show a few stats from these assemblies. Use the dropdown to
            go
            through each of the five samples.</p>
        <p>First up is the BUSCO score, which is a measure of completeness of a genome.</p>
    </div>
    <select id="busco_plot">
        <option value="drMalSylv7">drMalSylv7</option>
        <option value="drMalDome58">drMalDome58</option>
        <option value="drMalDome11">drMalDome11</option>
        <option value="drMalDome5">drMalDome5</option>
        <option value="drMalDome10">drMalDome10</option>
    </select>
    <div id="plot4"></div>
    <div>
        <p>Next up is number of contigs.</p>
    </div>
    <select id="contig_plot">
        <option value="drMalSylv7">drMalSylv7</option>
        <option value="drMalDome58">drMalDome58</option>
        <option value="drMalDome11">drMalDome11</option>
        <option value="drMalDome5">drMalDome5</option>
        <option value="drMalDome10">drMalDome10</option>
    </select>
    <div id="plot5"></div>
    <div>
        <p>
            These contigs will be scaffolded to hopefully produce the 16 (diploid) apple chromosomes.
        </p>
    </div>
    <div>
        <p>
            And lastly, contig N50.
        </p>
    </div>
    <select id="n50_plot">
        <option value="drMalSylv7">drMalSylv7</option>
        <option value="drMalDome58">drMalDome58</option>
        <option value="drMalDome11">drMalDome11</option>
        <option value="drMalDome5">drMalDome5</option>
        <option value="drMalDome10">drMalDome10</option>
    </select>
    <div id="plot6"></div>
    <h2>Analysis plans</h2>
    <div>
        <p>Now that we have all this data, what to do with it all? Last meeting there were a few suggestions which I
            will
            synthesise here, and perhaps suggest a few more. I\'ll note here that there are really two aims:</p>
        <ul>
            <li>Analyses for Apple Day</li>
            <li>Analyses beyond Apple Day</li>
        </ul>
    </div>
    <h3>Whole genome analysis</h3>
    <div>
        <ol>
            <li>
                A good idea to start off, might be to run some simple stats across the five genomes.
                <ul>
                    <li>
                        How big are they?
                    </li>
                    <li>
                        Do
                        they
                        show
                        patterns of GC content or information content across the chromosomes?
                    </li>
                    <li>
                        How does repeat
                        content vary
                        across
                        the
                        chromosomes?
                    </li>
                    <li>
                        These stats can then be eyeballed between the genomes, and generates some nice
                        graphs
                        really
                        quickly.
                    </li>
                </ul>
            </li>
            <li>
                We could map the HiFi reads of the cultivars to the wild apple reference genome to see where the major
                structural
                differences lie between domesticated and wild apples.
            </li>
        </ol>
        <p>Later on it might be nice to see where the haplotypic differences lie in each of the whole apple genomes. I\'m
            thinking <i>deepvariant</i>. Or later on we can characterise the repeatome.
        <p>
    </div>
    <h3>Cultivar resequencing analyses</h3>
    <div>
        <ol>
            <li>For apple day, something readily achievable and quick to do would be to map the Newton\'s apple reads to
                the
                Newton\'s
                apple reference genome.
                <ul>
                    <li>
                        Are they the same thing?
                    </li>
                    <li>
                        How many differences are there?
                    </li>
                    <li>
                        Where are these differences?
                    </li>
                    <li>
                        Also, seeing as Newton\'s apple is a triploid, what is this third copy?
                    </li>
                </ul>
            </li>
            <li>It would be good to characterise the diversity of these apples. This would mean
                mapping
                all the cultivars to one of the references (<i>which one?</i>). The resulting VCF can be wrangled in all
                sorts
                of
                ways to visualise the differences. A straightforward analysis would be along the lines of a PCA, or
                building
                a
                neighbour joining tree.
                <ul>
                    <li>
                        Do we see clusters?
                    </li>
                    <li>
                        Why might there be clusters?
                    </li>
                </ul>
            </li>
        </ol>
    </div>
    <h3>Beyond Apple Day</h3>
    <div>
        <ul>
            <li>Bring in the other SRA sequence data</li>
            <li>Look at regions known to be selected in the apples</li>
            <li>Pushing more pangenome analyses (but see Sun <i>et al</i>., 2020)</li>
            <li>Whole genome alignment of the five references. Look for CNE\'s?</li>
            <li>Detailed characterisation of the repeatome</li>
            <li>Anything else..?</li>
        </ul>
    </div>
    <div>
        <p>
            Follow the updates on <a href="https://github.com/tolkit/apple_day">GitHub</a>.
        </p>
    </div>
    <script type="module">
        import * as d3 from "https://cdn.skypack.dev/d3@7";
        // hardcode the data?
        // put data on one veeeery long line.
        const data = {0}
        // some global vars
        const height = 400;
        const width = 600;
        const margin = {{ top: 30, right: 0, bottom: 40, left: 40 }}
        function plot1_data() {{
            // unique source-specimen pairs
            let dat = data
                .map(function (d) {{
                    return {{
                        source: d.source,
                        specimen: d.specimen
                    }};
                }})
                .map((d) => JSON.stringify(d));
            let dat2 = new Set(dat);
            let dat3 = Array.from(dat2)
                .map((d) => JSON.parse(d))
                .map((d) => d.source);
            const counts = {{}};
            for (const ent of dat3) {{
                if (ent === undefined) continue;
                counts[ent] = counts[ent] ? counts[ent] + 1 : 1;
            }}
            let res = {{}};
            let res_arr = [];
            for (const key in counts) {{
                res_arr.push({{
                    platform: key,
                    value: counts[key]
                }});
            }}
            return res_arr;
        }}
        const _plot1_data = plot1_data();
        const _plot2_data = Array.from(
            new Set(
                data
                    .map(function (d) {{
                        return {{
                            source: d.source,
                            specimen: d.specimen,
                            haploid: d.haploid,
                            species: d.species,
                            k: +d.kmer
                        }};
                    }})
                    .map((d) => JSON.stringify(d))
            )
        )
            .map((d) => JSON.parse(d))
            .filter((d) => d.haploid > 0)
        const _plot3_data = Array.from(
            new Set(
                data
                    .map(function (d) {{
                        return {{
                            source: d.source,
                            specimen: d.specimen,
                            repeat: d.repeat,
                            species: d.species,
                            k: +d.kmer
                        }};
                    }})
                    .map((d) => JSON.stringify(d))
            )
        )
            .map((d) => JSON.parse(d))
            .filter((d) => d.repeat > 0)
        function plot1() {{
            const seq_count_plot = d3
                .select("#plot1")
                .append("svg")
                .attr("height", height)
                .attr("width", width);
            const xplot1 = d3
                .scaleBand()
                .domain(d3.range(_plot1_data.length))
                .range([margin.left, width - margin.right])
                .padding(0.1);
            const xAxisplot1 = (g) =>
                g
                    .attr("transform", `translate(0,${{height - margin.bottom}})`)
                    .call(
                        d3
                            .axisBottom(xplot1)
                            .tickFormat((i) => _plot1_data[i].platform)
                            .tickSizeOuter(0)
                    )
                    .call((g) =>
                        g
                            .append("text")
                            .attr("x", width / 1.5)
                            .attr("y", 35)
                            .attr("fill", "currentColor")
                            .attr("font-weight", "bold")
                            .attr("text-anchor", "end")
                            .text("Sequence data type")
                    );
            const yplot1 = d3
                .scaleLinear()
                .domain([0, d3.max(_plot1_data, (d) => d.value)])
                .nice()
                .range([height - margin.bottom, margin.top]);
            const yAxisplot1 = (g) =>
                g
                    .attr("transform", `translate(${{margin.left}},0)`)
                    .call(d3.axisLeft(yplot1).ticks(null, _plot1_data.format))
                    .call((g) => g.select(".domain").remove())
                    .call((g) =>
                        g
                            .select(".tick:last-of-type text")
                            .clone()
                            .attr("x", 4)
                            .attr("text-anchor", "start")
                            .attr("font-weight", "bold")
                            .text("Count")
                    );
            seq_count_plot
                .append("g")
                .attr("fill", "#a1d99b")
                .selectAll("rect")
                .data(plot1_data)
                .join("rect")
                .attr("x", (d, i) => xplot1(i))
                .attr("y", (d) => yplot1(d.value))
                .attr("height", (d) => yplot1(0) - yplot1(d.value))
                .attr("width", xplot1.bandwidth())
                .append("title")
                .text((d) => d.value + " cultivars");
            seq_count_plot.append("g").call(xAxisplot1);
            seq_count_plot.append("g").call(yAxisplot1);
        }}
        function plot2() {{
            // distribution of..?
            const svg = d3
                .select("#plot2")
                .append("svg")
                .attr("height", height)
                .attr("width", width);
            const data = _plot2_data
                .filter((d) => d.source === "illumina")
                .filter((d) => d.k === 21)
                .map((d) => d.haploid);
            const binsplot2 = d3.bin().thresholds(40)(data);
            const xplot2 = d3
                .scaleLinear()
                .domain([binsplot2[0].x0, binsplot2[binsplot2.length - 1].x1])
                .range([margin.left, width - margin.right - 10]);
            const yplot2 = d3
                .scaleLinear()
                .domain([0, d3.max(binsplot2, (d) => d.length)])
                .range([height - margin.bottom, margin.top]);
            const xAxisplot2 = (g) =>
                g
                    .attr("transform", `translate(0,${{height - margin.bottom}})`)
                    .call(
                        d3
                            .axisBottom(xplot2)
                            .ticks(6)
                            .tickFormat((x) => `${{x / 1000000}} Mb`)
                    )
                    .call((g) =>
                        g
                            .append("text")
                            .attr("x", width / 2)
                            .attr("y", 35)
                            .attr("fill", "currentColor")
                            .attr("font-weight", "bold")
                            .attr("text-anchor", "end")
                            .text("Haploid genome size")
                    );
            const yAxisplot2 = (g) =>
                g
                    .attr("transform", `translate(${{margin.left}},0)`)
                    .call(d3.axisLeft(yplot2).ticks(height / 40))
                    .call((g) => g.select(".domain").remove())
                    .call((g) =>
                        g
                            .select(".tick:last-of-type text")
                            .clone()
                            .attr("x", 4)
                            .attr("text-anchor", "start")
                            .attr("font-weight", "bold")
                            .text("Count")
                    );
            svg
                .append("g")
                .attr("fill", "#a1d99b")
                .selectAll("rect")
                .data(binsplot2)
                .join("rect")
                .attr("x", (d) => xplot2(d.x0) + 1)
                .attr("width", (d) => Math.max(0, xplot2(d.x1) - xplot2(d.x0) - 1))
                .attr("y", (d) => yplot2(d.length))
                .attr("height", (d) => yplot2(0) - yplot2(d.length))
                .append("title")
                .text((d) => `${{d.length}} cultivars`);
            svg.append("g").call(xAxisplot2);
            svg.append("g").call(yAxisplot2);
        }}
        function plot3() {{
            const svg = d3
                .select("#plot3")
                .append("svg")
                .attr("height", height)
                .attr("width", width);
            const data = _plot3_data
                .filter((d) => d.source === "illumina")
                .filter((d) => d.k === 21)
                .filter((d) => d.repeat < 100)
                .map((d) => d.repeat);
            const binsplot3 = d3.bin().thresholds(10)(data);
            const xplot3 = d3
                .scaleLinear()
                .domain([binsplot3[0].x0, binsplot3[binsplot3.length - 1].x1])
                .range([margin.left, width - margin.right - 10]);
            const yplot3 = d3
                .scaleLinear()
                .domain([0, d3.max(binsplot3, (d) => d.length)])
                .range([height - margin.bottom, margin.top]);
            const xAxisplot3 = (g) =>
                g
                    .attr("transform", `translate(0,${{height - margin.bottom}})`)
                    .call(
                        d3
                            .axisBottom(xplot3)
                            .ticks(6)
                            .tickFormat((x) => `${{x}}%`)
                    )
                    .call((g) =>
                        g
                            .append("text")
                            .attr("x", width / 2)
                            .attr("y", 35)
                            .attr("fill", "currentColor")
                            .attr("font-weight", "bold")
                            .attr("text-anchor", "end")
                            .text("Repeat content")
                    );
            const yAxisplot3 = (g) =>
                g
                    .attr("transform", `translate(${{margin.left}},0)`)
                    .call(d3.axisLeft(yplot3).ticks(height / 40))
                    .call((g) => g.select(".domain").remove())
                    .call((g) =>
                        g
                            .select(".tick:last-of-type text")
                            .clone()
                            .attr("x", 4)
                            .attr("text-anchor", "start")
                            .attr("font-weight", "bold")
                            .text("Count")
                    );
            svg
                .append("g")
                .attr("fill", "#a1d99b")
                .selectAll("rect")
                .data(binsplot3)
                .join("rect")
                .attr("x", (d) => xplot3(d.x0) + 1)
                .attr("width", (d) => Math.max(0, xplot3(d.x1) - xplot3(d.x0) - 1))
                .attr("y", (d) => yplot3(d.length))
                .attr("height", (d) => yplot3(0) - yplot3(d.length))
                .append("title")
                .text((d) => `${{d.length}} cultivars`);
            svg.append("g").call(xAxisplot3);
            svg.append("g").call(yAxisplot3);
        }}
        // call plots
        plot1()
        plot2()
        plot3()
        // add the variables
        const malus_cultivars = Array.from(
            new Set(data.filter((d) => d.specimen !== "?").map((d) => d.cultivar))
        ).filter((e) => e !== "Wild" && e !== "")
        const malus_species = Array.from(new Set(data.map((d) => d.species))).join(", ")
        const number_of_species = new Set(data.map((d) => d.species)).size
        const sylvestris_individuals = Array.from(
            new Set(
                data
                    .map(function (d) {{
                        return {{
                            source: d.source,
                            specimen: d.specimen
                        }};
                    }})
                    .map((d) => JSON.stringify(d))
            )
        )
            .map((d) => JSON.parse(d))
            .filter((d) => d.specimen.includes("Sylv"))
            .filter((d) => d.source === "illumina").length
        document.getElementById("stat4").innerHTML = sylvestris_individuals
        document.getElementById("stat3").innerHTML = malus_cultivars.length
        document.getElementById("stat2").innerHTML = malus_species
        document.getElementById("stat1").innerHTML = number_of_species
        // next set here
        // all_apples_merged_asm.json
        const asm = {1}
        function parseBusco(d) {{
            let spl_arr = d.split(/\[|\]|,/).filter((d) => d !== "");
            let obj = {{}};
            for (const e of spl_arr) {{
                let test = e.charAt(0);
                switch (test) {{
                    case "C":
                        obj["Complete"] = e.split(":")[1];
                        break;
                    case "S":
                        obj["Single copy"] = e.split(":")[1];
                        break;
                    case "D":
                        obj["Duplicated"] = e.split(":")[1];
                        break;
                    case "F":
                        obj["Fragmented"] = e.split(":")[1];
                        break;
                    case "M":
                        obj["Missing"] = e.split(":")[1];
                        break;
                    case "n":
                        obj["Number"] = e.split(":")[1];
                        break;
                    default:
                        console.log("Nothing");
                }}
            }}
            return obj;
        }}
        const plot4_data = asm.map(function (d) {{
            let buscos = parseBusco(d.BUSCO);
            return {{
                specimen: d.specimen,
                asm: d.asm,
                complete: +buscos.Complete.replace("%", ""),
                "single copy": +buscos["Single copy"].replace("%", ""),
                duplicated: +buscos.Duplicated.replace("%", ""),
                fragmented: +buscos.Fragmented.replace("%", ""),
                missing: +buscos.Missing.replace("%", ""),
                number: +buscos.Number
            }};
        }});
        const series = d3
            .stack()
            .keys(new Set(plot4_data.map((d) => d.specimen)))(plot4_data)
            .map((d) => (d.forEach((v) => (v.key = d.key)), d))
        const keys = Object.keys(plot4_data[0])
            .slice(2)
            .filter((d) => d !== "number")
        function plot4() {{
            let S = document.getElementById("busco_plot");
            let SPECIMEN = S.value;
            d3.select("#plot4").selectAll("*").remove();
            const svg = d3
                .select("#plot4")
                .append("svg")
                .attr("height", height)
                .attr("width", width + 50);
            // axes et al
            const color = d3
                .scaleOrdinal()
                .range(["#edf8e9", "#bae4b3", "#74c476", "#31a354", "#006d2c"].reverse())
            const x0 = d3
                .scaleBand()
                .domain(plot4_data.map((d) => d["asm"]))
                .rangeRound([margin.left, width - margin.right])
                .paddingInner(0.1)
            const x1 = d3.scaleBand().domain(keys).rangeRound([0, x0.bandwidth()]).padding(0.05)
            const xAxis = (g) =>
                g
                    .attr("transform", `translate(0,${{height - margin.bottom}})`)
                    .call(d3.axisBottom(x0).tickSizeOuter(0))
                    .call((g) => g.select(".domain").remove())
            const y = d3
                .scaleLinear()
                .domain([0, d3.max(plot4_data, (d) => d3.max(keys, (key) => d[key]))])
                .nice()
                .rangeRound([height - margin.bottom, margin.top])
            const yAxis = (g) =>
                g
                    .attr("transform", `translate(${{margin.left}},0)`)
                    .call(d3.axisLeft(y).ticks(null, "s"))
                    .call((g) => g.select(".domain").remove())
                    .call((g) =>
                        g
                            .select(".tick:last-of-type text")
                            .clone()
                            .attr("x", 3)
                            .attr("y", -10)
                            .attr("text-anchor", "start")
                            .attr("font-weight", "bold")
                            .text(SPECIMEN)
                    )
            const legend = (svg) => {{
                const g = svg
                    .attr("transform", `translate(${{width + 20}},0)`)
                    .attr("text-anchor", "end")
                    .attr("font-family", "sans-serif")
                    .attr("font-size", 10)
                    .selectAll("g")
                    .data(color.domain().slice())
                    .join("g")
                    .attr("transform", (d, i) => `translate(0,${{i * 20}})`);
                g.append("rect")
                    .attr("x", -19)
                    .attr("width", 19)
                    .attr("height", 19)
                    .attr("fill", color);
                g.append("text")
                    .attr("x", -24)
                    .attr("y", 9.5)
                    .attr("dy", "0.35em")
                    .text((d) => d);
            }}
            svg
                .append("g")
                .selectAll("g")
                .data(plot4_data.filter((d) => d.specimen === SPECIMEN))
                .join("g")
                .attr("transform", (d) => `translate(${{x0(d["asm"])}},0)`)
                .selectAll("rect")
                .data((d) => keys.map((key) => ({{ key, value: d[key] }})))
                .join("rect")
                .attr("x", (d) => x1(d.key))
                .attr("y", (d) => y(d.value))
                .attr("width", x1.bandwidth())
                .attr("height", (d) => y(0) - y(d.value))
                .attr("fill", (d) => color(d.key))
                .append("title")
                .text(d => d.value + "%")
            svg.append("g").call(xAxis);
            svg.append("g").call(yAxis);
            svg.append("g").call(legend);
        }}
        const plot5_data = asm.map(function (d) {{
            return {{
                specimen: d.specimen,
                asm: d.asm,
                contigs: d.contigs
            }};
        }})
        function plot5() {{
            let S = document.getElementById("contig_plot");
            let SPECIMEN = S.value;
            d3.select("#plot5").selectAll("*").remove();
            const svg = d3
                .select("#plot5")
                .append("svg")
                .attr("height", height)
                .attr("width", width);
            const data = plot5_data.filter((d) => d.specimen === SPECIMEN);
            const xplot1 = d3
                .scaleBand()
                .domain(["hifiasm", "hifiasm.purging", "hicanu", "hicanu.purging"])
                .range([margin.left, width - margin.right])
                .padding(0.1);
            const xAxisplot1 = (g) =>
                g
                    .attr("transform", `translate(0,${{height - margin.bottom}})`)
                    .call(
                        d3
                            .axisBottom(xplot1)
                            .tickFormat((i) => i)
                            .tickSizeOuter(0)
                    )
                    .call((g) =>
                        g
                            .append("text")
                            .attr("x", width / 1.5)
                            .attr("y", 35)
                            .attr("fill", "currentColor")
                            .attr("font-weight", "bold")
                            .attr("text-anchor", "end")
                            .text("Sequence data type")
                    );
            const yplot1 = d3
                .scaleLinear()
                .domain([0, d3.max(data, (d) => d.contigs)])
                .nice()
                .range([height - margin.bottom, margin.top]);
            const yAxisplot1 = (g) =>
                g
                    .attr("transform", `translate(${{margin.left}},0)`)
                    .call(d3.axisLeft(yplot1).ticks(null, data.format))
                    .call((g) => g.select(".domain").remove())
                    .call((g) =>
                        g
                            .select(".tick:last-of-type text")
                            .clone()
                            .attr("x", 4)
                            .attr("text-anchor", "start")
                            .attr("font-weight", "bold")
                            .text("Count")
                    );
            svg
                .append("g")
                .attr("fill", "#a1d99b")
                .selectAll("rect")
                .data(data)
                .join("rect")
                .attr("x", (d) => xplot1(d.asm))
                .attr("y", (d) => yplot1(d.contigs))
                .attr("height", (d) => yplot1(0) - yplot1(d.contigs))
                .attr("width", xplot1.bandwidth())
                .append("title")
                .text((d) => d.contigs + " contigs");
            svg.append("g").call(xAxisplot1);
            svg.append("g").call(yAxisplot1);
        }}
        const plot6_data = asm.map(function (d) {{
            return {{
                specimen: d.specimen,
                asm: d.asm,
                ncontig50: d.ncontig50
            }};
        }})
        function plot6() {{
            let S = document.getElementById("n50_plot");
            let SPECIMEN = S.value;
            d3.select("#plot6").selectAll("*").remove();
            const svg = d3
                .select("#plot6")
                .append("svg")
                .attr("height", height)
                .attr("width", width);
            const data = plot6_data.filter((d) => d.specimen === SPECIMEN);
            const xplot1 = d3
                .scaleBand()
                .domain(["hifiasm", "hifiasm.purging", "hicanu", "hicanu.purging"])
                .range([margin.left, width - margin.right])
                .padding(0.1);
            const xAxisplot1 = (g) =>
                g
                    .attr("transform", `translate(0,${{height - margin.bottom}})`)
                    .call(
                        d3
                            .axisBottom(xplot1)
                            .tickFormat((i) => i)
                            .tickSizeOuter(0)
                    )
                    .call((g) =>
                        g
                            .append("text")
                            .attr("x", width / 1.5)
                            .attr("y", 35)
                            .attr("fill", "currentColor")
                            .attr("font-weight", "bold")
                            .attr("text-anchor", "end")
                            .text("Sequence data type")
                    );
            const yplot1 = d3
                .scaleLinear()
                .domain([0, d3.max(data, (d) => d.ncontig50)])
                .nice()
                .range([height - margin.bottom, margin.top]);
            const yAxisplot1 = (g) =>
                g
                    .attr("transform", `translate(${{margin.left}},0)`)
                    .call(d3.axisLeft(yplot1).tickFormat((d) => d / 1000000 + " Mb"))
                    .call((g) => g.select(".domain").remove())
                    .call((g) =>
                        g
                            .select(".tick:last-of-type text")
                            .clone()
                            .attr("x", 4)
                            .attr("text-anchor", "start")
                            .attr("font-weight", "bold")
                            .text("Contig N50")
                    );
            svg
                .append("g")
                .attr("fill", "#a1d99b")
                .selectAll("rect")
                .data(data)
                .join("rect")
                .attr("x", (d, i) => xplot1(d.asm))
                .attr("y", (d) => yplot1(d.ncontig50))
                .attr("height", (d) => yplot1(0) - yplot1(d.ncontig50))
                .attr("width", xplot1.bandwidth())
                .append("title")
                .text((d) => "Contig N50 = " + (Math.round(d.ncontig50 / 1000000 * 100) / 100) + " Mb");
            svg.append("g").call(xAxisplot1);
            svg.append("g").call(yAxisplot1);
        }}
        plot4()
        // and listen for change
        document.getElementById("busco_plot").onchange = plot4;
        plot5()
        // and listen for change
        document.getElementById("contig_plot").onchange = plot5;
        plot6()
        document.getElementById("n50_plot").onchange = plot6;
    </script>
</body>
</html>
""".format(
    all_apples_merged,
    all_apples_merged_asm,
)

print(html_string)
