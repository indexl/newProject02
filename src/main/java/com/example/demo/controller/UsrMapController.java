package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class UsrMapController {
	
	 @GetMapping("/usr/api/map1")
	    public String showMap1() {
	        return "usr/api/map1";
	 }
	 
	 @GetMapping("/usr/api/map2")
	    public String showMap2() {
	        return "usr/api/map2";
	 } 
	 
	 @GetMapping("/usr/api/map3")
	    public String showMap3() {
	        return "usr/api/map3";
	 }
	 
	 @GetMapping("/usr/api/map4")
	    public String showMap4() {
	        return "usr/api/map4";
	 }
	 
	 @GetMapping("/usr/api/map5")
	    public String showMap5() {
	        return "usr/api/map5";
	 }
	 
	 @GetMapping("/usr/api/map6")
	    public String showMap6() {
	        return "usr/api/map6";
	 }
	 
	 @GetMapping("/usr/api/capture")
	    public String showMap7() {
	        return "usr/api/capture";
	 }
}