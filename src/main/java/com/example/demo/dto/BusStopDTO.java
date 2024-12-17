package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class BusStopDTO {
    private double lat;
    private double lng;
    private String stationName;
    private String stationId;
}