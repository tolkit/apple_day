function makeAssemblyDiagram(
    words,
    len = 30,
    overlap = 15,
    id = "example",
    width
) {
    // chunk an array into overlapping windows
    // https://stackoverflow.com/questions/14985948/split-array-into-overlapping-chunks-moving-subgroups
    // with edits
    function chunk(array, chunkSize, stepSize) {
        let retArr = [];
        let i = 0;
        for (i; i < array.length - (chunkSize - 1); i += stepSize) {
            retArr.push(array.slice(i, i + chunkSize));
        }
        if (i < array.length - 1) retArr.push(array.slice(i));
        return retArr;
    }

    let chunksArray = chunk(words.split(""), len, overlap);
    // https://www.codegrepper.com/code-examples/javascript/repeat+array+n+times+javascript
    const makeRepeated = (arr, repeats) =>
        Array.from({ length: repeats }, () => arr).flat();
    // make the colour scale
    const colourScale = d3
        .scaleOrdinal()
        .domain("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split(""))
        .range(makeRepeated(["blue", "green", "red", "yellow"], 13));

    const svg = d3
        .select(id)
        .append("svg")
        .attr("width", width)
        .attr("height", 33 * chunksArray.length)
        .attr("viewBox", `0 -20 ${width} ${33 * chunksArray.length}`)
        .attr("id", "dtol_svg");

    for (let j = 0; j < chunksArray.length; j++) {
        // text
        svg
            .append("g")
            .selectAll("text")
            .data(chunksArray[j])
            .join("text")
            .attr("x", (d, i) => i * 25 + 1)
            .attr("y", 0 + j * 33)
            .attr("text-anchor", "middle")
            .text((d) => d)
            .attr("transform", "translate(10)");

        // rects
        svg
            .append("g")
            .selectAll("rect")
            .data(chunksArray[j])
            .join("rect")
            .attr("id", (d) => d)
            .attr("x", (d, i) => i * 25 - 3)
            .attr("y", -15 + j * 33)
            .attr("width", 19)
            .attr("height", 20)
            .attr("stroke", (d) => colourScale(d))
            .attr("stroke-width", "2")
            .attr("fill", "none")
            .attr("transform", "translate(5)");
    }
}