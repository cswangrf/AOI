import numpy
from PyQt5.QtCore import QCoreApplication

def getHistogramImage(pixels, size):
    """
    @use:
    img = Image.open(filepath)
    img = img.convert(mode='RGB')
    img = img.resize(size, Image.ANTIALIAS)
    histogramR, histogramG, histogramB = get_histogramRGB(img, size)
    """
    histogram1 = numpy.zeros(256)
    histogram2 = numpy.zeros(256)
    histogram3 = numpy.zeros(256)
    for i in range(size[0]):
        QCoreApplication.processEvents()
        for j in range(size[1]):
            channel1, channel2, channel3 = pixels[i, j]
            histogram1[channel1] += 1
            histogram2[channel2] += 1
            histogram3[channel3] += 1
    return histogram1, histogram2, histogram3

def getHistogramArray(npPixels):
    histogram1 = numpy.zeros(361)
    histogram2 = numpy.zeros(101)
    histogram3 = numpy.zeros(101)
    for pixels in npPixels:
        QCoreApplication.processEvents()
        for pixel in pixels:
            channel1, channel2, channel3 = pixel
            while channel1 >= 361:
                channel1 = channel1 - 361
            if channel2 >= 101:
                channel2 = 100
            if channel3 >= 101:
                channel3 = 100

            histogram1[int(channel1)] += 1
            histogram2[int(channel2)] += 1
            histogram3[int(channel3)] += 1
    return histogram1, histogram2, histogram3
