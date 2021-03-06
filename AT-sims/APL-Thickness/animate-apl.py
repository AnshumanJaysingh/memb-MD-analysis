import imageio
import os
import sys


path = os.getcwd()
image_folder = os.fsencode(path)
filenames = []

for file in os.listdir(image_folder):
    filename = os.fsdecode(file)
    if filename.endswith( ('.jpeg', '.png', '.gif') ):
        filenames.append(filename)

filenames.sort() # this iteration technique has no built in order, so sort the frames
images = list(map(lambda filename: imageio.imread(filename), filenames))

imageio.mimsave(os.path.join('aplmovie.gif'), images, duration = 0.04) # modify duration as needed
imageio.mimsave(os.path.join('aplmovie.mp4'), images)
