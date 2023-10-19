$infile = "../../data/pa_greatmarsh_2014.copc.laz"
$outfile = "../../data/-a_greatmarsh_2014_dem.tif"

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
      "type":"filters.delaunay",
      "where":"Classification == 2"
    },
    {
      "type":"filters.faceraster",
      "resolution": 1,
      "width": 5000,
      "height": 5000,
      "origin_x": 0,
      "origin_y": 0
    },
    {
      "type": "writers.raster",
      "filename": "outputfile.tif"
    }
  ]
}
"@


$pipeline | & "pdal" pipeline --stdin `
  --readers.las.filename=$infile `
  --filters.delaunay.where="Classification == 2" `
  --filters.faceraster.resolution=$res `
  --filters.faceraster.width=$([Int](($window.maxx-$window.minx)*(1/$res))) `
  --filters.faceraster.height=$([Int](($window.maxy-$window.miny)*(1/$res))) `
  --filters.faceraster.origin_x=$($window.minx) `
  --filters.faceraster.origin_y=$($window.miny) `
  --writers.raster.filename=$outfile
