from __future__ import division
import configparser
import os
import math
import time
from numpy import savez_compressed
import pandas as pd
import link_budget as lb
from inputs import lut
from tqdm import tqdm

path = "C:/Users/bmwan/Desktop/5.2/Link Budget/results/"
df = pd.read_csv(path + "uq_parameters.csv")
uq_dict = df.to_dict('records')

uq_results = []

for item in tqdm(uq_dict, desc = "Processing uncertainity results"):

    constellation = item["constellation"]

    number_of_satellites = item["number_of_satellites"]

    path_loss = lb.path_loss(item["altitude_km"], item["dl_frequency_Hz"])
    
    antenna_gain = lb.antenna_gain(item["antenna_efficiency"], item["antenna_diameter_m"], item["dl_frequency_Hz"])

    total_losses = lb.total_losses(item["earth_atmospheric_losses_dB"], item["all_other_losses_dB"]) 

    cnr_scenario = item["cnr_scenario"]

    eirp = lb.eirp(item["power_dBw"], antenna_gain)
    
    power_received_user = lb.power_received_user(eirp, path_loss, total_losses, item["receiver_gain_dB"] )

    noise_power = lb.noise_power(290, item["dl_bandwidth_Hz"]) 

    signal_to_noise_ratio = lb.signal_to_noise_ratio(power_received_user, noise_power)

    spectral_efficiency = lb.spectral_efficiency(signal_to_noise_ratio)

    channel_capacity = lb.channel_capacity(spectral_efficiency, item["dl_bandwidth_Hz"])

    satellite_capacity = lb.satellite_capacity(spectral_efficiency, item["dl_bandwidth_Hz"], item["number_of_channels"], item["polarization"])

    constellation_capacity = lb.constellation_capacity(satellite_capacity, item["number_of_satellites"])

    capacity_area = lb.capacity_area(constellation_capacity, item["coverage_area_per_sat_sqkm"])

    capex = item["capex_costs"]

    capex_scenario = item["capex_scenario"]

    total_opex  = item["opex_costs"]

    opex_scenario = item["opex_scenario"]
    
    satellite_launch_cost = item["satellite_launch_cost"]

    cost_scenario = item["cost_scenario"]
    

    cost_model = lb.cost_model(item["satellite_manufacturing"], item["satellite_launch_cost"], item["ground_station_cost"]
                              ,item["spectrum_cost"], item["regulation_fees"], item["digital_infrastructure_cost"],
                               item["ground_station_energy"], item["subscriber_acquisition"], item["staff_costs"], 
                               item["research_development"], item["maintenance_costs"], item["discount_rate"], 
                               item["assessment_period_year"])

    uq_results.append({"constellation": constellation, "path_loss": path_loss, "antenna_gain": antenna_gain, 
                    "total_losses": total_losses, "eirp": eirp, "power_received_user": power_received_user, "noise_power": noise_power, 
                    "signal_to_noise_ratio":signal_to_noise_ratio, "spectral_efficiency":spectral_efficiency, "channel capacity":channel_capacity,
                    "single_satellite_capacity_in_Gbps": satellite_capacity, "constelation_capacity":constellation_capacity, "capacity_area_GBps":capacity_area, "cost_model":cost_model, "cnr_scenario":cnr_scenario,
                    "capex_costs":capex, "capex_scenario":capex_scenario, "opex_costs":total_opex, "opex_scenario":opex_scenario,
                     "satellite_launch_cost":satellite_launch_cost, "cost_scenario": cost_scenario})
                      
df = pd.DataFrame.from_dict(uq_results)
df.to_csv(path + "uq_results.csv")
print ("Task Completed")