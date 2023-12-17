import os
import configparser
import warnings
import numpy as np
import pandas as pd
import geopandas as gpd
import matplotlib.pyplot as plt
import seaborn as sns
import contextily as ctx
from pylab import *
pd.options.mode.chained_assignment = None
warnings.filterwarnings('ignore')

BASE_PATH = os.getcwd()
DATA_PROCESS = os.path.join(BASE_PATH, 'data')
DATA_GEO = os.path.join(BASE_PATH, 'data', 'shapefiles')
VIS = os.path.join(BASE_PATH, 'figures')

def get_regional_shapes():
    """
    Load regional shapes.

    """
    output = []
        
    filename_gid2 = 'regions_2_KEN.shp'
    path_gid2 = os.path.join(DATA_GEO, filename_gid2)

    data = gpd.read_file(path_gid2)
    data['GID_id'] = data['GID_2']
    data = data.to_dict('records')

    for datum in data:
        output.append({
            'geometry': datum['geometry'],
            'properties': {
                'GID_1': datum['GID_id'],
            },
        })

    output = gpd.GeoDataFrame.from_features(output, crs = 'epsg:4326')
    

    return output


def plot_regions_by_geotype(constellation, metrics):
    """
    Plot population density 
    by regions.

    """

    regions = get_regional_shapes()
    DATA_KENYA = os.path.join(DATA_PROCESS, '{}_final_final.csv'.format(constellation))
    
    data = pd.read_csv(DATA_KENYA)
    n = int((len(data)))
    data[metrics] = round(data[metrics])
    data = data[['GID_1', metrics]]
    regions = regions[['GID_1', 'geometry']]#[:1000]
    regions = regions.copy()

    regions = regions.merge(data, left_on = 'GID_1', right_on = 'GID_1')
    regions.reset_index(drop = True, inplace = True)

    metric = metrics
    bins = [-1, 1, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8.5, 10]
    labels = [
        '<20 Mbps/user',
        '20-43 $\mathregular{km^2}$',
        '43-69 $\mathregular{km^2}$',
        '69-109 $\mathregular{km^2}$',
        '109-171 $\mathregular{km^2}$',
        '171-257 $\mathregular{km^2}$',
        '257-367 $\mathregular{km^2}$',
        '367-541 $\mathregular{km^2}$',
        '541-1104 $\mathregular{km^2}$',
        '>1104 $\mathregular{km^2}$']

    regions['bin'] = pd.cut(
        regions[metric],
        bins = bins,
        labels = labels)

    sns.set(font_scale = 0.9)
    fig, ax = plt.subplots(1, 1, figsize = (10, 10))

    base = regions.plot(column = 'bin', ax = ax, 
        cmap = 'YlGnBu', linewidth = 0.2,
        legend=True, edgecolor = 'grey')

    handles, labels = ax.get_legend_handles_labels()

    fig.legend(handles[::-1], labels[::-1])

    ctx.add_basemap(ax, crs = regions.crs, source = ctx.providers.CartoDB.Voyager)

    name = 'Capacity per User for  {}'.format(constellation)
    ax.set_title(name, fontsize = 14)

    fig.tight_layout()
    path = os.path.join(VIS, '{}_{}.png'.format(constellation, metrics))
    fig.savefig(path)

    plt.close(fig)


if __name__ == '__main__':

    plot_regions_by_geotype('Starlink', 'capacity_user_mbps')