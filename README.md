# Exploring SystemD Replacement Start Order

Repo aiming to explore the various [start order options](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#Requires=) in SystemD and how they operate with [SystemD replacement](https://github.com/gdraheim/docker-systemctl-replacement).

## Prerequisite 

- Docker
- CentOS7 with SystemD (Run `./build-centos7-systemd.sh`)

## Running tests

You can run a scenario by running the following command.

`./test-scenario.sh {SCENARIO_PATH}` eg `./test-scenario.sh scenarios/1-oneshot-a-before-b`

The test scenario process is very manual as it stands. It expects you to tell it when you think the start-up process is complete and to move onto the next test step.

This command will;
- Run the scenario four times;
  1. Run with pure SystemD with service A exit 0
  2. Run with replacement SystemD with service A exit 0 
  3. Run with pure SystemD with service A exit 1
  4. Run with replacement SystemD with service A exit 1 
- Expect you to hit CMD+C when you deemed each run "finished". 
- After hitting CMD+C it'll take a screenshot, request the systemctl status of each service and screenshot that.
- It'll then move onto the next scenario step.

## Results

The screenshot results of each scenario can be found in the `./scenarios/**/results` directory. 

### Summary table 

| Scenario # 	| Description                       	| SystemD     	| Service A exit code 	| Expected B status      	| Actual B status        	| Pass |
|------------	|-----------------------------------	|-------------	|---------------------	|------------------------	|------------------------	|------|
| 1          	| Loose dependency. A sets Before=b 	| Pure        	| 0                   	| Running after start-up 	| Running after start-up 	| ✅   |
|            	|                                   	| Replacement 	| 0                   	| Running after start-up 	| Running after start-up 	| ✅   |
|            	|                                   	| Pure        	| 1                   	| Running after start-up 	| Running after start-up 	| ✅   |
|            	|                                   	| Replacement 	| 1                   	| Running after start-up 	| Running after start-up 	| ✅   |
| 2          	| A sets Before=b. B sets BindsTo=a 	| Pure        	| 0                   	| Running after start-up 	| Running after start-up 	| ✅   |
|            	|                                   	| Replacement 	| 0                   	| Running after start-up 	| Running after start-up 	| ✅   |
|            	|                                   	| Pure        	| 1                   	| Not running            	| Not running            	| ✅   |
|            	|                                   	| Replacement 	| 1                   	| Not running            	| Running after start-up 	| ❌   |
| 3           | Same as above but with a wait       |               |                       |                         |                         |      |
| 4           | A sets Before=b. B sets Requires=a  | Pure          | 0                     | Running after start-up 	| Running after start-up 	| ✅   |
|            	|                                   	| Replacement 	| 0                   	| Running after start-up 	| Running after start-up 	| ✅   |
|            	|                                   	| Pure        	| 1                   	| Not running            	| Not running            	| ✅   |
|            	|                                   	| Replacement 	| 1                   	| Not running            	| Running after start-up 	| ❌   |
| 5           | B sets After&Requires=a             | Pure          | 0                     | Running after start-up 	| Running after start-up 	| ✅   |
|            	|                                   	| Replacement 	| 0                   	| Running after start-up 	| Running after start-up 	| ✅   |
|            	|                                   	| Pure        	| 1                   	| Not running            	| Not running            	| ✅   |
|            	|                                   	| Replacement 	| 1                   	| Not running            	| Running after start-up 	| ❌   |
| 6           | B sets After&Requires&PartOf=a      | Pure          | 0                     | Running after start-up 	| Running after start-up 	| ✅   |
|            	|                                   	| Replacement 	| 0                   	| Running after start-up 	| Running after start-up 	| ✅   |
|            	|                                   	| Pure        	| 1                   	| Not running            	| Not running            	| ✅   |
|            	|                                   	| Replacement 	| 1                   	| Not running            	| Running after start-up 	| ❌   |

## Reading

- [SystemCTL replacement start order notes](https://github.com/gdraheim/docker-systemctl-replacement/blob/master/notes/STARTORDER.md)
- [SystemD section options](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#%5BUnit%5D%20Section%20Options)