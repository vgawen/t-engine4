-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2017 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

setStatusAll{no_teleport=true}

startx = 34
starty = 23
endx = 34
endy = 23

-- defineTile section
defineTile("#", "HARDWALL")
defineTile("&", "LAVA_WALL_OPAQUE")
defineTile("~", "LAVA_WALL")
defineTile("<", "UP")
defineTile("-", "SAND")
defineTile("O", "CONTROL_ORB")
defineTile(".", "FLOOR")
defineTile("@", "FLOOR", nil, "RING_MASTER")

-- addSpot section
addSpot({6, 19}, "npcs", "spectators")
addSpot({7, 19}, "npcs", "spectators")
addSpot({8, 19}, "npcs", "spectators")
addSpot({9, 19}, "npcs", "spectators")
addSpot({10, 19}, "npcs", "spectators")
addSpot({6, 20}, "npcs", "spectators")
addSpot({7, 20}, "npcs", "spectators")
addSpot({8, 20}, "npcs", "spectators")
addSpot({9, 20}, "npcs", "spectators")
addSpot({10, 20}, "npcs", "spectators")
addSpot({6, 21}, "npcs", "spectators")
addSpot({7, 21}, "npcs", "spectators")
addSpot({8, 21}, "npcs", "spectators")
addSpot({9, 21}, "npcs", "spectators")
addSpot({10, 21}, "npcs", "spectators")
addSpot({6, 22}, "npcs", "spectators")
addSpot({7, 22}, "npcs", "spectators")
addSpot({8, 22}, "npcs", "spectators")
addSpot({9, 22}, "npcs", "spectators")
addSpot({10, 22}, "npcs", "spectators")
addSpot({6, 23}, "npcs", "spectators")
addSpot({7, 23}, "npcs", "spectators")
addSpot({8, 23}, "npcs", "spectators")
addSpot({9, 23}, "npcs", "spectators")
addSpot({10, 23}, "npcs", "spectators")
addSpot({6, 24}, "npcs", "spectators")
addSpot({7, 24}, "npcs", "spectators")
addSpot({8, 24}, "npcs", "spectators")
addSpot({9, 24}, "npcs", "spectators")
addSpot({10, 24}, "npcs", "spectators")
addSpot({6, 25}, "npcs", "spectators")
addSpot({7, 25}, "npcs", "spectators")
addSpot({8, 25}, "npcs", "spectators")
addSpot({9, 25}, "npcs", "spectators")
addSpot({10, 25}, "npcs", "spectators")
addSpot({6, 26}, "npcs", "spectators")
addSpot({7, 26}, "npcs", "spectators")
addSpot({8, 26}, "npcs", "spectators")
addSpot({9, 26}, "npcs", "spectators")
addSpot({10, 26}, "npcs", "spectators")
addSpot({6, 27}, "npcs", "spectators")
addSpot({7, 27}, "npcs", "spectators")
addSpot({8, 27}, "npcs", "spectators")
addSpot({9, 27}, "npcs", "spectators")
addSpot({10, 27}, "npcs", "spectators")
addSpot({36, 19}, "npcs", "spectators")
addSpot({37, 19}, "npcs", "spectators")
addSpot({38, 19}, "npcs", "spectators")
addSpot({39, 19}, "npcs", "spectators")
addSpot({40, 19}, "npcs", "spectators")
addSpot({36, 20}, "npcs", "spectators")
addSpot({37, 20}, "npcs", "spectators")
addSpot({38, 20}, "npcs", "spectators")
addSpot({39, 20}, "npcs", "spectators")
addSpot({40, 20}, "npcs", "spectators")
addSpot({36, 21}, "npcs", "spectators")
addSpot({37, 21}, "npcs", "spectators")
addSpot({38, 21}, "npcs", "spectators")
addSpot({39, 21}, "npcs", "spectators")
addSpot({40, 21}, "npcs", "spectators")
addSpot({36, 22}, "npcs", "spectators")
addSpot({37, 22}, "npcs", "spectators")
addSpot({38, 22}, "npcs", "spectators")
addSpot({39, 22}, "npcs", "spectators")
addSpot({40, 22}, "npcs", "spectators")
addSpot({36, 23}, "npcs", "spectators")
addSpot({37, 23}, "npcs", "spectators")
addSpot({38, 23}, "npcs", "spectators")
addSpot({39, 23}, "npcs", "spectators")
addSpot({40, 23}, "npcs", "spectators")
addSpot({36, 24}, "npcs", "spectators")
addSpot({37, 24}, "npcs", "spectators")
addSpot({38, 24}, "npcs", "spectators")
addSpot({39, 24}, "npcs", "spectators")
addSpot({40, 24}, "npcs", "spectators")
addSpot({36, 25}, "npcs", "spectators")
addSpot({37, 25}, "npcs", "spectators")
addSpot({38, 25}, "npcs", "spectators")
addSpot({39, 25}, "npcs", "spectators")
addSpot({40, 25}, "npcs", "spectators")
addSpot({36, 26}, "npcs", "spectators")
addSpot({37, 26}, "npcs", "spectators")
addSpot({38, 26}, "npcs", "spectators")
addSpot({39, 26}, "npcs", "spectators")
addSpot({40, 26}, "npcs", "spectators")
addSpot({36, 27}, "npcs", "spectators")
addSpot({37, 27}, "npcs", "spectators")
addSpot({38, 27}, "npcs", "spectators")
addSpot({39, 27}, "npcs", "spectators")
addSpot({40, 27}, "npcs", "spectators")
addSpot({19, 6}, "npcs", "spectators")
addSpot({20, 6}, "npcs", "spectators")
addSpot({21, 6}, "npcs", "spectators")
addSpot({22, 6}, "npcs", "spectators")
addSpot({23, 6}, "npcs", "spectators")
addSpot({24, 6}, "npcs", "spectators")
addSpot({25, 6}, "npcs", "spectators")
addSpot({26, 6}, "npcs", "spectators")
addSpot({27, 6}, "npcs", "spectators")
addSpot({19, 7}, "npcs", "spectators")
addSpot({20, 7}, "npcs", "spectators")
addSpot({21, 7}, "npcs", "spectators")
addSpot({22, 7}, "npcs", "spectators")
addSpot({23, 7}, "npcs", "spectators")
addSpot({24, 7}, "npcs", "spectators")
addSpot({25, 7}, "npcs", "spectators")
addSpot({26, 7}, "npcs", "spectators")
addSpot({27, 7}, "npcs", "spectators")
addSpot({19, 8}, "npcs", "spectators")
addSpot({20, 8}, "npcs", "spectators")
addSpot({21, 8}, "npcs", "spectators")
addSpot({22, 8}, "npcs", "spectators")
addSpot({23, 8}, "npcs", "spectators")
addSpot({24, 8}, "npcs", "spectators")
addSpot({25, 8}, "npcs", "spectators")
addSpot({26, 8}, "npcs", "spectators")
addSpot({27, 8}, "npcs", "spectators")
addSpot({19, 9}, "npcs", "spectators")
addSpot({20, 9}, "npcs", "spectators")
addSpot({21, 9}, "npcs", "spectators")
addSpot({22, 9}, "npcs", "spectators")
addSpot({23, 9}, "npcs", "spectators")
addSpot({24, 9}, "npcs", "spectators")
addSpot({25, 9}, "npcs", "spectators")
addSpot({26, 9}, "npcs", "spectators")
addSpot({27, 9}, "npcs", "spectators")
addSpot({19, 10}, "npcs", "spectators")
addSpot({20, 10}, "npcs", "spectators")
addSpot({21, 10}, "npcs", "spectators")
addSpot({22, 10}, "npcs", "spectators")
addSpot({23, 10}, "npcs", "spectators")
addSpot({24, 10}, "npcs", "spectators")
addSpot({25, 10}, "npcs", "spectators")
addSpot({26, 10}, "npcs", "spectators")
addSpot({27, 10}, "npcs", "spectators")
addSpot({19, 36}, "npcs", "spectators")
addSpot({20, 36}, "npcs", "spectators")
addSpot({21, 36}, "npcs", "spectators")
addSpot({22, 36}, "npcs", "spectators")
addSpot({23, 36}, "npcs", "spectators")
addSpot({24, 36}, "npcs", "spectators")
addSpot({25, 36}, "npcs", "spectators")
addSpot({26, 36}, "npcs", "spectators")
addSpot({27, 36}, "npcs", "spectators")
addSpot({19, 37}, "npcs", "spectators")
addSpot({20, 37}, "npcs", "spectators")
addSpot({21, 37}, "npcs", "spectators")
addSpot({22, 37}, "npcs", "spectators")
addSpot({23, 37}, "npcs", "spectators")
addSpot({24, 37}, "npcs", "spectators")
addSpot({25, 37}, "npcs", "spectators")
addSpot({26, 37}, "npcs", "spectators")
addSpot({27, 37}, "npcs", "spectators")
addSpot({19, 38}, "npcs", "spectators")
addSpot({20, 38}, "npcs", "spectators")
addSpot({21, 38}, "npcs", "spectators")
addSpot({22, 38}, "npcs", "spectators")
addSpot({23, 38}, "npcs", "spectators")
addSpot({24, 38}, "npcs", "spectators")
addSpot({25, 38}, "npcs", "spectators")
addSpot({26, 38}, "npcs", "spectators")
addSpot({27, 38}, "npcs", "spectators")
addSpot({19, 39}, "npcs", "spectators")
addSpot({20, 39}, "npcs", "spectators")
addSpot({21, 39}, "npcs", "spectators")
addSpot({22, 39}, "npcs", "spectators")
addSpot({23, 39}, "npcs", "spectators")
addSpot({24, 39}, "npcs", "spectators")
addSpot({25, 39}, "npcs", "spectators")
addSpot({26, 39}, "npcs", "spectators")
addSpot({27, 39}, "npcs", "spectators")
addSpot({19, 40}, "npcs", "spectators")
addSpot({20, 40}, "npcs", "spectators")
addSpot({21, 40}, "npcs", "spectators")
addSpot({22, 40}, "npcs", "spectators")
addSpot({23, 40}, "npcs", "spectators")
addSpot({24, 40}, "npcs", "spectators")
addSpot({25, 40}, "npcs", "spectators")
addSpot({26, 40}, "npcs", "spectators")
addSpot({27, 40}, "npcs", "spectators")
addSpot({9, 29}, "npcs", "spectators")
addSpot({10, 29}, "npcs", "spectators")
addSpot({11, 29}, "npcs", "spectators")
addSpot({12, 29}, "npcs", "spectators")
addSpot({9, 30}, "npcs", "spectators")
addSpot({10, 30}, "npcs", "spectators")
addSpot({11, 30}, "npcs", "spectators")
addSpot({12, 30}, "npcs", "spectators")
addSpot({9, 31}, "npcs", "spectators")
addSpot({10, 31}, "npcs", "spectators")
addSpot({11, 31}, "npcs", "spectators")
addSpot({12, 31}, "npcs", "spectators")
addSpot({9, 32}, "npcs", "spectators")
addSpot({10, 32}, "npcs", "spectators")
addSpot({11, 32}, "npcs", "spectators")
addSpot({12, 32}, "npcs", "spectators")
addSpot({9, 33}, "npcs", "spectators")
addSpot({10, 33}, "npcs", "spectators")
addSpot({11, 33}, "npcs", "spectators")
addSpot({12, 33}, "npcs", "spectators")
addSpot({13, 34}, "npcs", "spectators")
addSpot({14, 34}, "npcs", "spectators")
addSpot({15, 34}, "npcs", "spectators")
addSpot({16, 34}, "npcs", "spectators")
addSpot({17, 34}, "npcs", "spectators")
addSpot({13, 35}, "npcs", "spectators")
addSpot({14, 35}, "npcs", "spectators")
addSpot({15, 35}, "npcs", "spectators")
addSpot({16, 35}, "npcs", "spectators")
addSpot({17, 35}, "npcs", "spectators")
addSpot({13, 36}, "npcs", "spectators")
addSpot({14, 36}, "npcs", "spectators")
addSpot({15, 36}, "npcs", "spectators")
addSpot({16, 36}, "npcs", "spectators")
addSpot({17, 36}, "npcs", "spectators")
addSpot({13, 37}, "npcs", "spectators")
addSpot({14, 37}, "npcs", "spectators")
addSpot({15, 37}, "npcs", "spectators")
addSpot({16, 37}, "npcs", "spectators")
addSpot({17, 37}, "npcs", "spectators")
addSpot({29, 34}, "npcs", "spectators")
addSpot({30, 34}, "npcs", "spectators")
addSpot({31, 34}, "npcs", "spectators")
addSpot({32, 34}, "npcs", "spectators")
addSpot({33, 34}, "npcs", "spectators")
addSpot({29, 35}, "npcs", "spectators")
addSpot({30, 35}, "npcs", "spectators")
addSpot({31, 35}, "npcs", "spectators")
addSpot({32, 35}, "npcs", "spectators")
addSpot({33, 35}, "npcs", "spectators")
addSpot({29, 36}, "npcs", "spectators")
addSpot({30, 36}, "npcs", "spectators")
addSpot({31, 36}, "npcs", "spectators")
addSpot({32, 36}, "npcs", "spectators")
addSpot({33, 36}, "npcs", "spectators")
addSpot({29, 37}, "npcs", "spectators")
addSpot({30, 37}, "npcs", "spectators")
addSpot({31, 37}, "npcs", "spectators")
addSpot({32, 37}, "npcs", "spectators")
addSpot({33, 37}, "npcs", "spectators")
addSpot({29, 9}, "npcs", "spectators")
addSpot({30, 9}, "npcs", "spectators")
addSpot({31, 9}, "npcs", "spectators")
addSpot({32, 9}, "npcs", "spectators")
addSpot({33, 9}, "npcs", "spectators")
addSpot({29, 10}, "npcs", "spectators")
addSpot({30, 10}, "npcs", "spectators")
addSpot({31, 10}, "npcs", "spectators")
addSpot({32, 10}, "npcs", "spectators")
addSpot({33, 10}, "npcs", "spectators")
addSpot({29, 11}, "npcs", "spectators")
addSpot({30, 11}, "npcs", "spectators")
addSpot({31, 11}, "npcs", "spectators")
addSpot({32, 11}, "npcs", "spectators")
addSpot({33, 11}, "npcs", "spectators")
addSpot({29, 12}, "npcs", "spectators")
addSpot({30, 12}, "npcs", "spectators")
addSpot({31, 12}, "npcs", "spectators")
addSpot({32, 12}, "npcs", "spectators")
addSpot({33, 12}, "npcs", "spectators")
addSpot({13, 9}, "npcs", "spectators")
addSpot({14, 9}, "npcs", "spectators")
addSpot({15, 9}, "npcs", "spectators")
addSpot({16, 9}, "npcs", "spectators")
addSpot({17, 9}, "npcs", "spectators")
addSpot({13, 10}, "npcs", "spectators")
addSpot({14, 10}, "npcs", "spectators")
addSpot({15, 10}, "npcs", "spectators")
addSpot({16, 10}, "npcs", "spectators")
addSpot({17, 10}, "npcs", "spectators")
addSpot({13, 11}, "npcs", "spectators")
addSpot({14, 11}, "npcs", "spectators")
addSpot({15, 11}, "npcs", "spectators")
addSpot({16, 11}, "npcs", "spectators")
addSpot({17, 11}, "npcs", "spectators")
addSpot({13, 12}, "npcs", "spectators")
addSpot({14, 12}, "npcs", "spectators")
addSpot({15, 12}, "npcs", "spectators")
addSpot({16, 12}, "npcs", "spectators")
addSpot({17, 12}, "npcs", "spectators")
addSpot({34, 29}, "npcs", "spectators")
addSpot({35, 29}, "npcs", "spectators")
addSpot({36, 29}, "npcs", "spectators")
addSpot({37, 29}, "npcs", "spectators")
addSpot({34, 30}, "npcs", "spectators")
addSpot({35, 30}, "npcs", "spectators")
addSpot({36, 30}, "npcs", "spectators")
addSpot({37, 30}, "npcs", "spectators")
addSpot({34, 31}, "npcs", "spectators")
addSpot({35, 31}, "npcs", "spectators")
addSpot({36, 31}, "npcs", "spectators")
addSpot({37, 31}, "npcs", "spectators")
addSpot({34, 32}, "npcs", "spectators")
addSpot({35, 32}, "npcs", "spectators")
addSpot({36, 32}, "npcs", "spectators")
addSpot({37, 32}, "npcs", "spectators")
addSpot({34, 33}, "npcs", "spectators")
addSpot({35, 33}, "npcs", "spectators")
addSpot({36, 33}, "npcs", "spectators")
addSpot({37, 33}, "npcs", "spectators")
addSpot({34, 13}, "npcs", "spectators")
addSpot({35, 13}, "npcs", "spectators")
addSpot({36, 13}, "npcs", "spectators")
addSpot({37, 13}, "npcs", "spectators")
addSpot({34, 14}, "npcs", "spectators")
addSpot({35, 14}, "npcs", "spectators")
addSpot({36, 14}, "npcs", "spectators")
addSpot({37, 14}, "npcs", "spectators")
addSpot({34, 15}, "npcs", "spectators")
addSpot({35, 15}, "npcs", "spectators")
addSpot({36, 15}, "npcs", "spectators")
addSpot({37, 15}, "npcs", "spectators")
addSpot({34, 16}, "npcs", "spectators")
addSpot({35, 16}, "npcs", "spectators")
addSpot({36, 16}, "npcs", "spectators")
addSpot({37, 16}, "npcs", "spectators")
addSpot({34, 17}, "npcs", "spectators")
addSpot({35, 17}, "npcs", "spectators")
addSpot({36, 17}, "npcs", "spectators")
addSpot({37, 17}, "npcs", "spectators")
addSpot({9, 13}, "npcs", "spectators")
addSpot({10, 13}, "npcs", "spectators")
addSpot({11, 13}, "npcs", "spectators")
addSpot({12, 13}, "npcs", "spectators")
addSpot({9, 14}, "npcs", "spectators")
addSpot({10, 14}, "npcs", "spectators")
addSpot({11, 14}, "npcs", "spectators")
addSpot({12, 14}, "npcs", "spectators")
addSpot({9, 15}, "npcs", "spectators")
addSpot({10, 15}, "npcs", "spectators")
addSpot({11, 15}, "npcs", "spectators")
addSpot({12, 15}, "npcs", "spectators")
addSpot({9, 16}, "npcs", "spectators")
addSpot({10, 16}, "npcs", "spectators")
addSpot({11, 16}, "npcs", "spectators")
addSpot({12, 16}, "npcs", "spectators")
addSpot({9, 17}, "npcs", "spectators")
addSpot({10, 17}, "npcs", "spectators")
addSpot({11, 17}, "npcs", "spectators")
addSpot({12, 17}, "npcs", "spectators")
addSpot({28, 23}, "arena", "npc")
addSpot({19, 23}, "arena", "player")

-- addZone section

-- ASCII map section
return [[
##################################################
##################################################
##################################################
##################################################
##################################################
##################################################
###################.........######################
#################.............####################
###############.................##################
#############.....................################
############.......................###############
###########.........~~~~~~~.........##############
##########........~~~.....~~~........#############
#########.......~~~.........~~~.......############
#########......~~.............~~......############
########......~~.....&&&&&.....~~......###########
########.....~~....&&&---&&&....~~.....###########
#######......~....&&-------&&....~......##########
#######.....~~...&&---------&&...~~.....##########
######......~...&&-----------&&...~......#########
######.....~~...&-------------&...~~.....#########
######.....~...&&----#---#----&&...~.....#########
######.....~...&---------------&...~.....#########
######.....~..O&---------------&@.<~.....#########
######.....~...&---------------&...~.....#########
######.....~...&&----#---#----&&...~.....#########
######.....~~...&-------------&...~~.....#########
######......~...&&-----------&&...~......#########
#######.....~~...&&---------&&...~~.....##########
#######......~....&&-------&&....~......##########
########.....~~....&&&---&&&....~~.....###########
########......~~.....&&&&&.....~~......###########
#########......~~.............~~......############
#########.......~~~.........~~~.......############
##########........~~~.....~~~........#############
###########.........~~~~~~~.........##############
############.......................###############
#############.....................################
###############.................##################
#################.............####################
###################.........######################
##################################################
##################################################
##################################################
##################################################
##################################################
##################################################
##################################################
##################################################
##################################################]]