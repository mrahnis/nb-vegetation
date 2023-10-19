$infile = "../../data/pa_greatmarsh_2014.copc.laz"
$outfile = "../../data/pa_greatmarsh_2014_chm.tif"

# $res = 0.6
$res = 0.5999999999999999778
$window = [ordered]@{
  minx=433779.5999999999767169; `
  miny=4441729.7999999998137355; `
  maxx=435549.5999999999767169; `
  maxy=4443000.0000000000000000; }

$pipeline = @"
{
  "pipeline": [
    {
      "type":"readers.las",
      "filename":"example.laz"
    },
    {
        "type":"filters.hag_delaunay"
    },
    {
        "type":"filters.ferry",
        "dimensions":"HeightAboveGround=Z"
    },
    {
      "type":"filters.range",
      "limits":"Classification[1:1]"
    },
    {
      "type":"writers.gdal",
      "filename":"output.tif",
      "gdalopts": "tiled=true,compress=LZW",
      "resolution": 1,
      "radius": 2,
      "output_type": "idw"
    }
  ]
}
"@

$bounds = "([$($window.minx), $($window.maxx)]," +
           "[$($window.miny), $($window.maxy)])"

$pipeline | & "pdal" pipeline --stdin `
  --readers.las.filename=$infile `
  --writers.gdal.bounds=$bounds `
  --writers.gdal.resolution=$res `
  --writers.gdal.filename=$outfile
