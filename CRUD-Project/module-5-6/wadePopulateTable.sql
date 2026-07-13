/*
    Original Author: Wade Eckert
    Professor: John Woods
    Course: CSD 430 - Server Side Development
    Assignment: Modules 5.2 and 6.2 - CRUD Project Part 1
    Date: July 12, 2026
    File Name: wadePopulateTable.sql
    Description: Selects the CSD430 database and populates the
                 wade_states_data table with records for all
                 50 United States.

    Population Source:
    StatsAmerica, "Population Estimate for 2025."
    Original Data Source: U.S. Census Bureau.
    Accessed: July 12, 2026.
*/


/* Select the project database. */
USE CSD430;


/* Insert records for all 50 U.S. states. The state_id field is omitted because MySQL generates it automatically using AUTO_INCREMENT. */
INSERT INTO wade_states_data (
    state_name,
    state_abbreviation,
    capital,
    population,
    population_year,
    state_bird,
    state_flower
)

VALUES
    ('Alabama', 'AL', 'Montgomery', 5193088, 2025, 'Yellowhammer', 'Camellia'),
    ('Alaska', 'AK', 'Juneau', 737270, 2025, 'Willow Ptarmigan', 'Forget-Me-Not'),
    ('Arizona', 'AZ', 'Phoenix', 7623818, 2025, 'Cactus Wren', 'Saguaro Blossom'),
    ('Arkansas', 'AR', 'Little Rock', 3114791, 2025, 'Mockingbird', 'Apple Blossom'),
    ('California', 'CA', 'Sacramento', 39355309, 2025, 'California Quail', 'California Poppy'),
    ('Colorado', 'CO', 'Denver', 6012561, 2025, 'Lark Bunting', 'Rocky Mountain Columbine'),
    ('Connecticut', 'CT', 'Hartford', 3688496, 2025, 'American Robin', 'Mountain Laurel'),
    ('Delaware', 'DE', 'Dover', 1059952, 2025, 'Blue Hen Chicken', 'Peach Blossom'),
    ('Florida', 'FL', 'Tallahassee', 23462518, 2025, 'Northern Mockingbird', 'Orange Blossom'),
    ('Georgia', 'GA', 'Atlanta', 11302748, 2025, 'Brown Thrasher', 'Cherokee Rose'),
    ('Hawaii', 'HI', 'Honolulu', 1432820, 2025, 'Nēnē', 'Yellow Hibiscus'),
    ('Idaho', 'ID', 'Boise', 2029733, 2025, 'Mountain Bluebird', 'Syringa'),
    ('Illinois', 'IL', 'Springfield', 12719141, 2025, 'Northern Cardinal', 'Purple Violet'),
    ('Indiana', 'IN', 'Indianapolis', 6973333, 2025, 'Northern Cardinal', 'Peony'),
    ('Iowa', 'IA', 'Des Moines', 3238387, 2025, 'Eastern Goldfinch', 'Wild Prairie Rose'),
    ('Kansas', 'KS', 'Topeka', 2977220, 2025, 'Western Meadowlark', 'Sunflower'),
    ('Kentucky', 'KY', 'Frankfort', 4606864, 2025, 'Northern Cardinal', 'Goldenrod'),
    ('Louisiana', 'LA', 'Baton Rouge', 4618189, 2025, 'Brown Pelican', 'Magnolia'),
    ('Maine', 'ME', 'Augusta', 1414874, 2025, 'Black-capped Chickadee', 'White Pine Cone and Tassel'),
    ('Maryland', 'MD', 'Annapolis', 6265347, 2025, 'Baltimore Oriole', 'Black-Eyed Susan'),
    ('Massachusetts', 'MA', 'Boston', 7154084, 2025, 'Black-capped Chickadee', 'Mayflower'),
    ('Michigan', 'MI', 'Lansing', 10127884, 2025, 'American Robin', 'Apple Blossom'),
    ('Minnesota', 'MN', 'Saint Paul', 5830405, 2025, 'Common Loon', 'Pink and White Lady''s Slipper'),
    ('Mississippi', 'MS', 'Jackson', 2954160, 2025, 'Mockingbird', 'Magnolia'),
    ('Missouri', 'MO', 'Jefferson City', 6270541, 2025, 'Eastern Bluebird', 'Hawthorn Blossom'),
    ('Montana', 'MT', 'Helena', 1144694, 2025, 'Western Meadowlark', 'Bitterroot'),
    ('Nebraska', 'NE', 'Lincoln', 2018006, 2025, 'Western Meadowlark', 'Goldenrod'),
    ('Nevada', 'NV', 'Carson City', 3282188, 2025, 'Mountain Bluebird', 'Sagebrush'),
    ('New Hampshire', 'NH', 'Concord', 1415342, 2025, 'Purple Finch', 'Purple Lilac'),
    ('New Jersey', 'NJ', 'Trenton', 9548215, 2025, 'Eastern Goldfinch', 'Purple Violet'),
    ('New Mexico', 'NM', 'Santa Fe', 2125498, 2025, 'Greater Roadrunner', 'Yucca Flower'),
    ('New York', 'NY', 'Albany', 20002427, 2025, 'Eastern Bluebird', 'Rose'),
    ('North Carolina', 'NC', 'Raleigh', 11197968, 2025, 'Northern Cardinal', 'Flowering Dogwood'),
    ('North Dakota', 'ND', 'Bismarck', 799358, 2025, 'Western Meadowlark', 'Wild Prairie Rose'),
    ('Ohio', 'OH', 'Columbus', 11900510, 2025, 'Northern Cardinal', 'Scarlet Carnation'),
    ('Oklahoma', 'OK', 'Oklahoma City', 4123288, 2025, 'Scissor-tailed Flycatcher', 'Oklahoma Rose'),
    ('Oregon', 'OR', 'Salem', 4273586, 2025, 'Western Meadowlark', 'Oregon Grape'),
    ('Pennsylvania', 'PA', 'Harrisburg', 13059432, 2025, 'Ruffed Grouse', 'Mountain Laurel'),
    ('Rhode Island', 'RI', 'Providence', 1114521, 2025, 'Rhode Island Red', 'Violet'),
    ('South Carolina', 'SC', 'Columbia', 5570274, 2025, 'Carolina Wren', 'Yellow Jessamine'),
    ('South Dakota', 'SD', 'Pierre', 935094, 2025, 'Ring-necked Pheasant', 'American Pasque Flower'),
    ('Tennessee', 'TN', 'Nashville', 7315076, 2025, 'Northern Mockingbird', 'Iris'),
    ('Texas', 'TX', 'Austin', 31709821, 2025, 'Northern Mockingbird', 'Bluebonnet'),
    ('Utah', 'UT', 'Salt Lake City', 3538904, 2025, 'California Gull', 'Sego Lily'),
    ('Vermont', 'VT', 'Montpelier', 644663, 2025, 'Hermit Thrush', 'Red Clover'),
    ('Virginia', 'VA', 'Richmond', 8880107, 2025, 'Northern Cardinal', 'Flowering Dogwood'),
    ('Washington', 'WA', 'Olympia', 8001020, 2025, 'American Goldfinch', 'Coast Rhododendron'),
    ('West Virginia', 'WV', 'Charleston', 1766147, 2025, 'Northern Cardinal', 'Big Rhododendron'),
    ('Wisconsin', 'WI', 'Madison', 5972787, 2025, 'American Robin', 'Wood Violet'),
    ('Wyoming', 'WY', 'Cheyenne', 588753, 2025, 'Western Meadowlark', 'Indian Paintbrush');