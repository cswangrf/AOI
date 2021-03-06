"""
    @package imageСomparison
    Image Сomparison
"""
import sys
import os
import numpy
import matplotlib.pyplot as plt
import random
import time

import math
sys.path.append(os.path.abspath(os.path.dirname(__file__) + '/' + '../..'))

from imageFilters import filters, adaptiveFilter
from imageProcessor import colorModel, histogramService, imageService
from PyQt5.QtCore import QCoreApplication, QDir 
from PyQt5.QtCore import QObject, pyqtSlot
from PyQt5.QtQml import QJSValue
from PIL import Image

def getImages(appDir):
    imageServices = imageService.ImageService(appDir)
    imgOriginal = imageServices.openImage(True)
    imgProcessed = imageServices.openImage(False)
    if imgOriginal is None or imgProcessed is None:
        return None, None

    imgOriginal = numpy.asarray(imgOriginal, dtype="float")
    imgProcessed = numpy.asarray(imgProcessed, dtype="float")
    return imgOriginal, imgProcessed

def calculateMSE(appDir):
    """
        Calculate PSNR
    """
    imgOriginal, imgProcessed = getImages(appDir)
    if imgOriginal is None: 0

    mse = numpy.mean((imgOriginal - imgProcessed) ** 2)
    return mse

def calculatePSNR(appDir):
    """
        Calculate PSNR
    """
    mse = calculateMSE(appDir)
    if mse == 0:
        return (100, 0)
    PIXEL_MAX = 255.0
    psnr = 20 * math.log10(PIXEL_MAX / math.sqrt(mse))
    return (mse, psnr)

def rmsDifference(appDir):
    """
        Calculate root mean square difference of two images
    """
    imgOriginal, imgProcessed = getImages(appDir)
    if imgOriginal is None: 0
    return numpy.sqrt(numpy.mean(numpy.square(imgOriginal - imgProcessed)))


def calculateImageDifference(colorModelTag, logFile):
    appDir = logFile.split('/temp/')[0]
    mse, psnr = calculatePSNR(appDir)
    rms = rmsDifference(appDir)

    with open(logFile, "a+") as text_file:
        if colorModelTag is not None:
            text_file.write("MSE: {}: {}\n".format(colorModelTag, mse))
            text_file.write("PSNR: {}: {}\n".format(colorModelTag, psnr))
            text_file.write("RMS: {}: {}\n".format(colorModelTag, rms))
        else:
            text_file.write("MSE: {}\n".format(mse))
            text_file.write("PSNR: {}\n".format(psnr))
            text_file.write("RMS: {}\n".format(rms))

def calculateSegmentationCriterias(logFile, data1, data2, segmentCount, isReturn=False):
    # get image area, perimeter and Center of mass
    area = 0
    perimetr = 0
    pointYsum = 0
    pointXsum = 0
    size = data1.shape

    for i in range(size[0]):
        for j in range(size[1]):
            if any(data1[i, j] != 0):
                area += 1
                pointXsum += i
                pointYsum += j
            if any(data2[i, j] != 0):
                perimetr += 1
    centerOfMass = (pointXsum/area, pointYsum/area)
    compactness = (perimetr**2)/area

    # img1 = Image.fromarray(numpy.asarray(numpy.clip(data1, 0, 255), dtype="uint8"))
    # img2 = Image.fromarray(numpy.asarray(numpy.clip(data2, 0, 255), dtype="uint8"))
    # # img1.show()
    # img2.show()
    edgeList = []
    for i in range(size[0]):
        for j in range(size[1]):
            if any(data1[i, j] != 0):
                edgeList.append((i,j))
    chainCode8 = ''
    for i in range(len(edgeList)):
        if i == 0:
            continue;
        point1 = edgeList[i - 1]
        point2 = edgeList[i]
        x1 = point1[0]
        y1 = point1[1]
        x2 = point2[0]
        y2 = point2[1]
        while x1 != x2 or y1 != y2:
            if x1 < x2:
                x1 += 1
                if y1 < y2:
                    chainCode8 += '5'
                    y1 += 1
                elif y1 > y2:
                    y1 -= 1
                    chainCode8 += '3'
                else:
                    chainCode8 += '4'
            elif x1 > x2:
                x1 -= 1
                if y1 < y2:
                    y1 += 1
                    chainCode8 += '7'
                elif y1 > y2:
                    y1 -= 1
                    chainCode8 += '1'
                else:
                    chainCode8 += '0'
            else:
                if y1 > y2:
                    y1 -= 1
                    chainCode8 += '2'
                elif y1 < y2:
                    y1 += 1
                    chainCode8 += '6'

    with open(logFile.replace('.log', 'ChainCode.txt').replace('log/', ''), 'w') as text_file:
        text_file.write(chainCode8)

    if isReturn:
        return area, perimetr, centerOfMass, compactness, segmentCount
    with open(logFile, 'a+') as text_file:
        text_file.write('Area: {}\n'.format(area))
        text_file.write('Perimetr: {}\n'.format(perimetr))
        text_file.write('Center of mass: {}\n'.format(centerOfMass))
        text_file.write('Compactness: {}\n'.format(compactness))
        text_file.write('Segments count: {}\n'.format(segmentCount))

def calculateSegmentationDifferences(logFile, data1EGBIS, data2EGBIS, segmentCountEGBIS, forest,
        data1SPHC, data2SPHC, segmentCountSPHC, segm_dict):

    # for y in range(height):
    #     for x in range(width):
    #         comp = forest.find(y * width + x)
    width = data1EGBIS.shape[1]
    sumOfSimilar = 0
    sumOfCoinciding = 0
    for k, v in segm_dict.items():
        last_parent = -1
        sumOfPixels = 0
        coordTest = (0, 0)
        for i, coord in enumerate(v['coord']):
            if i == 0:
                last_parent = forest.nodes[coord[0] * width + coord[1]].parent
                coordTest = coord
            if forest.nodes[coord[0] * width + coord[1]].parent == last_parent:
                sumOfPixels += 1
        a = forest.find(coordTest[0] * width + coordTest[1])
        forest_size = forest.size_of(a)
        comparePercent = float(sumOfPixels)/forest_size
        if comparePercent >= 0.5:
            sumOfSimilar += 1
        if comparePercent >= 0.9:
            sumOfCoinciding += 1

    areaEGBIS, perimetrEGBIS, centerOfMassEGBIS, compactnessEGBIS, segmentCountEGBIS =\
        calculateSegmentationCriterias(logFile, data1EGBIS, data2EGBIS,
            segmentCountEGBIS, isReturn=True)

    areaSPHC, perimetrSPHC, centerOfMassSPHC, compactnessSPHC, segmentCountSPHC =\
        calculateSegmentationCriterias(logFile, data1SPHC, data2SPHC,
            segmentCountSPHC, isReturn=True)

    with open(logFile, 'a+') as text_file:
        text_file.write('Area: EGBIS: {} SPHC: {}\n'\
            .format(areaEGBIS, areaSPHC))
        text_file.write('Perimetr: EGBIS: {} SPHC: {}\n'\
            .format(perimetrEGBIS, perimetrSPHC))
        text_file.write('Center of mass: EGBIS: {} SPHC: {}\n'\
            .format(centerOfMassEGBIS, centerOfMassSPHC))
        text_file.write('Compactness: EGBIS: {} SPHC: {}\n'\
            .format(compactnessEGBIS, compactnessSPHC))
        text_file.write('Segments count: EGBIS: {} SPHC: {}\n'\
            .format(segmentCountEGBIS, segmentCountSPHC))
        text_file.write('Sum of similar: {}\n'\
            .format(sumOfSimilar))
        text_file.write('Sum of coinciding: {}\n'\
            .format(sumOfCoinciding))

