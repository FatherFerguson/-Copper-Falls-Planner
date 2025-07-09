<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Copper Falls Interactive Trip Planner</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
    <!-- Chosen Palette: Earthy Harmony -->
    <!-- Application Structure Plan: A single-page, scroll-based application with a fixed top navigation bar. The structure follows a logical trip-planning progression: 1) Overview, 2) Plan Your Stay (interactive budget/campsite selection), 3) Explore Activities (filterable trails), 4) Get Prepared (interactive checklist), 5) The Journey (route info), and 6) Resources. This task-oriented flow is more intuitive for a user planning a trip than the original report's linear structure. It prioritizes key decisions like budget and lodging, then moves to activities and packing, making the planning process efficient and user-friendly. -->
    <!-- Visualization & Content Choices:
        - Report Info: Budgeting details (fees, fuel, food for residents/non-residents). Goal: Compare & Inform. Viz/Method: Interactive Bar Chart (Chart.js) and dynamic text. Interaction: Radio buttons for residency/site type update the chart and totals. Justification: Transforms a static table into a personalized cost estimation tool, providing immediate feedback on user choices.
        - Report Info: Campsite details (North vs. South). Goal: Compare. Viz/Method: HTML/CSS cards with icons (Unicode). Interaction: Toggling content or simple side-by-side view. Justification: More visually engaging and easier to scan for key differences than paragraphs of text.
        - Report Info: Hiking trail descriptions. Goal: Organize & Inform. Viz/Method: Grid of HTML/CSS cards. Interaction: Filter buttons (Pet-Friendly, Waterfalls, etc.) to show/hide relevant cards. Justification: Allows users to quickly find trails that match their interests and constraints (e.g., pets) without reading through all descriptions.
        - Report Info: Gear list. Goal: Organize. Viz/Method: Interactive checklist (HTML with JS for state). Interaction: Users can click checkboxes. Justification: Adds direct utility, allowing users to actively track their packing progress.
    -->
    <!-- CONFIRMATION: NO SVG graphics used. NO Mermaid JS used. -->
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #FDFBF8; /* Warm Neutral */
            color: #4F4A45; /* Dark Brown/Grey */
        }
        .nav-link {
            transition: color 0.3s, border-color 0.3s;
            border-bottom: 2px solid transparent;
        }
        .nav-link:hover, .nav-link.active {
            color: #A47E3B; /* Subtle Accent */
            border-bottom-color: #A47E3B;
        }
        .btn-primary {
            background-color: #6B8A7A; /* Muted Green */
            color: #FDFBF8;
            transition: background-color 0.3s;
        }
        .btn-primary:hover {
            background-color: #5A7B6A;
        }
        .btn-secondary {
            background-color: #EFEBE4; /* Light Neutral */
            color: #4F4A45;
            transition: background-color 0.3s, box-shadow 0.3s;
        }
        .btn-secondary:hover, .btn-secondary.active {
            background-color: #A47E3B;
            color: #FDFBF8;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .card {
            background-color: #FFFFFF;
            border: 1px solid #EFEBE4;
            border-radius: 0.75rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -2px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.07), 0 4px 6px -4px rgba(0, 0, 0, 0.07);
        }
        .chart-container {
            position: relative;
            width: 100%;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
            height: 350px;
            max-height: 400px;
        }
        @media (min-width: 768px) {
            .chart-container {
                height: 400px;
            }
        }
        input[type="radio"]:checked + label {
            background-color: #A47E3B;
            color: #FDFBF8;
            border-color: #A47E3B;
        }
        input[type="checkbox"]:checked {
             background-color: #6B8A7A;
             border-color: #6B8A7A;
        }
    </style>
</head>
<body class="antialiased">

    <header class="bg-white/80 backdrop-blur-sm sticky top-0 z-50 shadow-sm">
        <nav class="container mx-auto px-6 py-3">
            <div class="flex justify-between items-center">
                <a href="#" class="text-xl font-bold text-[#6B8A7A]">🏕️ Copper Falls Planner</a>
                <div class="hidden md:flex space-x-8">
                    <a href="#plan" class="nav-link pb-1">Plan Your Stay</a>
                    <a href="#activities" class="nav-link pb-1">Activities</a>
                    <a href="#prepare" class="nav-link pb-1">Prepare</a>
                    <a href="#journey" class="nav-link pb-1">The Journey</a>
                </div>
            </div>
        </nav>
    </header>

    <main>
        <section id="hero" class="py-16 md:py-24 text-center bg-[#EFEBE4]">
            <div class="container mx-auto px-6">
                <h1 class="text-4xl md:text-6xl font-bold text-[#4F4A45] mb-4">Your Adventure to Copper Falls Awaits</h1>
                <p class="text-lg md:text-xl text-[#4F4A45] max-w-3xl mx-auto">
                    This interactive guide translates the official trip plan into a dynamic tool. Plan your budget, pick a campsite, discover trails, and get ready for a memorable 2-3 day camping trip to one of Wisconsin's most scenic parks.
                </p>
            </div>
        </section>

        <section id="plan" class="py-16 md:py-24">
            <div class="container mx-auto px-6">
                <div class="text-center mb-12">
                    <h2 class="text-3xl md:text-4xl font-bold">Plan Your Stay</h2>
                    <p class="mt-4 text-lg max-w-3xl mx-auto">
                        Your first step is to plan the core logistics: your budget and your campsite. Use the interactive tools below to see how choices affect your trip's cost and find the perfect home base for your adventure. Remember to book reservations well in advance!
                    </p>
                </div>

                <div class="grid md:grid-cols-2 gap-12 items-start">
                    <div class="card p-6 md:p-8">
                        <h3 class="text-2xl font-bold mb-4">Interactive Budget Calculator</h3>
                        <p class="mb-6 text-[#4F4A45]">Select your residency and preferred site type to estimate the costs for a 2-person, 2-night trip. This helps visualize your expenses and make informed decisions.</p>
                        
                        <div class="space-y-4 mb-6">
                            <div>
                                <h4 class="font-semibold mb-2">1. Residency Status</h4>
                                <div class="flex gap-2" id="residency-toggle">
                                    <input type="radio" id="resident" name="residency" value="resident" class="hidden" checked>
                                    <label for="resident" class="flex-1 text-center py-2 px-4 rounded-md border border-gray-300 cursor-pointer transition-colors">WI Resident</label>
                                    <input type="radio" id="non-resident" name="residency" value="non-resident" class="hidden">
                                    <label for="non-resident" class="flex-1 text-center py-2 px-4 rounded-md border border-gray-300 cursor-pointer transition-colors">Non-Resident</label>
                                </div>
                            </div>
                            <div>
                                <h4 class="font-semibold mb-2">2. Campsite Type</h4>
                                <div class="flex gap-2" id="site-type-toggle">
                                    <input type="radio" id="non-electric" name="site-type" value="non-electric" class="hidden" checked>
                                    <label for="non-electric" class="flex-1 text-center py-2 px-4 rounded-md border border-gray-300 cursor-pointer transition-colors">Non-Electric</label>
                                    <input type="radio" id="electric" name="site-type" value="electric" class="hidden">
                                    <label for="electric" class="flex-1 text-center py-2 px-4 rounded-md border border-gray-300 cursor-pointer transition-colors">Electric</label>
                                </div>
                            </div>
                        </div>

                        <div class="chart-container mb-4">
                            <canvas id="budgetChart"></canvas>
                        </div>
                         <div class="text-center font-bold text-xl">
                            Estimated Total: <span id="total-cost" class="text-[#A47E3B]">$274 - $442</span>
                        </div>
                    </div>

                    <div class="space-y-8">
                        <div class="card p-6 md:p-8">
                            <h3 class="text-2xl font-bold mb-4">Choose Your Campsite</h3>
                            <p class="mb-6 text-[#4F4A45]">Copper Falls offers two main campgrounds, each with a different vibe. Your choice here sets the tone for your trip.</p>
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                                <div class="p-4 rounded-lg bg-[#EFEBE4]">
                                    <h4 class="font-bold text-lg mb-2">🏕️ North Campground</h4>
                                    <ul class="space-y-2 text-sm">
                                        <li><span class="font-semibold">Best for:</span> Convenience, RVs</li>
                                        <li>⚡ 28 of 32 sites have electricity</li>
                                        <li>🛣️ Paved roads for easy access</li>
                                        <li>🚽 Vault toilets available</li>
                                        <li><span class="font-semibold">Seclusion:</span> Less</li>
                                    </ul>
                                </div>
                                <div class="p-4 rounded-lg bg-[#EFEBE4]">
                                    <h4 class="font-bold text-lg mb-2">🌲 South Campground</h4>
                                    <ul class="space-y-2 text-sm">
                                        <li class="font-semibold">Best for:</span> Seclusion, traditional camping</li>
                                        <li>🔌 All 23 sites are non-electric</li>
                                        <li>🚿 Access to heated showers & flush toilets</li>
                                        <li>🚶 Includes 4 walk-in tent sites</li>
                                        <li><span class="font-semibold">Seclusion:</span> More</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="card p-6 md:p-8">
                            <h3 class="text-2xl font-bold mb-4">Key Reservation Rules</h3>
                             <ul class="space-y-3 text-[#4F4A45]">
                                <li><strong>Book Ahead:</strong> Reservations can be made up to 11 months in advance online or by phone. It's highly recommended for peak season.</li>
                                <li><strong>Check-in/Out:</strong> Check-in is 3:00 PM, check-out is 1:00 PM.</li>
                                <li><strong>Vehicle Limit:</strong> Max 2 vehicles per site.</li>
                                <li><strong>Firewood:</strong> Must be locally sourced or purchased near the park to prevent pest spread.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        
        <section id="activities" class="py-16 md:py-24 bg-[#EFEBE4]">
            <div class="container mx-auto px-6">
                <div class="text-center mb-12">
                    <h2 class="text-3xl md:text-4xl font-bold">Explore the Park</h2>
                    <p class="mt-4 text-lg max-w-3xl mx-auto">
                        With 17 miles of trails, stunning waterfalls, and a peaceful lake, there's no shortage of things to do. Use the filters below to find the perfect trail for your adventure, whether you're bringing a pet, seeking scenic views, or looking for an easy stroll.
                    </p>
                </div>
                
                <div class="flex justify-center flex-wrap gap-2 mb-8" id="trail-filters">
                    <button class="btn-secondary py-2 px-4 rounded-full active" data-filter="all">All Trails</button>
                    <button class="btn-secondary py-2 px-4 rounded-full" data-filter="waterfalls">🌊 Waterfalls</button>
                    <button class="btn-secondary py-2 px-4 rounded-full" data-filter="pet-friendly">🐾 Pet-Friendly</button>
                    <button class="btn-secondary py-2 px-4 rounded-full" data-filter="views">🔭 Great Views</button>
                    <button class="btn-secondary py-2 px-4 rounded-full" data-filter="easy">🚶 Easy</button>
                </div>

                <div id="trail-grid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                </div>
            </div>
        </section>

        <section id="prepare" class="py-16 md:py-24">
            <div class="container mx-auto px-6">
                <div class="text-center mb-12">
                    <h2 class="text-3xl md:text-4xl font-bold">Get Prepared</h2>
                    <p class="mt-4 text-lg max-w-3xl mx-auto">
                        A great trip starts with great preparation. Use the interactive checklist to make sure you've packed all the essentials, and read our bug protection strategy to stay comfortable in the great outdoors.
                    </p>
                </div>
                <div class="grid lg:grid-cols-2 gap-12">
                    <div class="card p-6 md:p-8">
                        <h3 class="text-2xl font-bold mb-4">Interactive Packing Checklist</h3>
                        <div id="checklist-container" class="space-y-6"></div>
                    </div>
                    <div class="card p-6 md:p-8">
                        <h3 class="text-2xl font-bold mb-4">Bug Protection Strategy 🦟</h3>
                        <p class="mb-4">Wisconsin woods are beautiful but buggy. Mosquitoes and ticks are common. Here’s how to stay protected:</p>
                        <ul class="space-y-4">
                            <li>
                                <h4 class="font-semibold">Effective Repellents</h4>
                                <p class="text-sm">Use repellents with DEET or Picaridin on skin. Treat clothing and gear (not skin) with Permethrin for long-lasting tick protection.</p>
                            </li>
                            <li>
                                <h4 class="font-semibold">Protective Clothing</h4>
                                <p class="text-sm">Wear long-sleeved shirts and pants, especially during dawn and dusk. Tucking pants into socks provides extra defense against ticks.</p>
                            </li>
                             <li>
                                <h4 class="font-semibold">Campsite Defense</h4>
                                <p class="text-sm">Consider a Thermacell device for a 15-foot zone of mosquito protection around your campsite (for outdoor use only).</p>
                            </li>
                            <li>
                                <h4 class="font-semibold">Perform Tick Checks</h4>
                                <p class="text-sm">After hiking, thoroughly check yourself, children, and pets for ticks. Early removal is key to preventing disease.</p>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </section>

        <section id="journey" class="py-16 md:py-24 bg-[#EFEBE4]">
            <div class="container mx-auto px-6">
                 <div class="text-center mb-12">
                    <h2 class="text-3xl md:text-4xl font-bold">The Journey from Chicago</h2>
                    <p class="mt-4 text-lg max-w-3xl mx-auto">
                        The 6-7 hour drive to Mellen, WI, is part of the adventure! Break up the trip with some of Wisconsin's classic roadside attractions. Be aware of potential detours on Highway 169 near the park through Fall 2025.
                    </p>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 text-center">
                    <div class="card p-6">
                        <div class="text-4xl mb-2">🧀</div>
                        <h4 class="font-bold">Mars Cheese Castle</h4>
                        <p class="text-sm">Kenosha, WI</p>
                    </div>
                    <div class="card p-6">
                        <div class="text-4xl mb-2">🐘</div>
                        <h4 class="font-bold">Pinkie the Elephant</h4>
                        <p class="text-sm">DeForest, WI</p>
                    </div>
                    <div class="card p-6">
                         <div class="text-4xl mb-2">🚲</div>
                        <h4 class="font-bold">World's Largest Bicyclist</h4>
                        <p class="text-sm">Sparta, WI</p>
                    </div>
                    <div class="card p-6">
                        <div class="text-4xl mb-2">🐟</div>
                        <h4 class="font-bold">World's Largest Fish</h4>
                        <p class="text-sm">Hayward, WI</p>
                    </div>
                </div>
            </div>
        </section>
        
         <section id="resources" class="py-16 md:py-24">
            <div class="container mx-auto px-6 text-center">
                <h2 class="text-3xl md:text-4xl font-bold mb-4">Quick Resources</h2>
                <p class="mt-2 text-lg max-w-2xl mx-auto mb-8">
                    Here are the essential links and numbers you'll need for your trip.
                </p>
                <div class="flex flex-col sm:flex-row justify-center items-center gap-4">
                     <a href="https://dnr.wisconsin.gov/topic/parks/copperfalls" target="_blank" class="btn-primary py-3 px-6 rounded-lg font-semibold">Official Park Website</a>
                     <a href="https://wisconsin.goingtocamp.com/" target="_blank" class="btn-primary py-3 px-6 rounded-lg font-semibold">Make a Reservation</a>
                     <p class="font-semibold text-lg">Park Office: <a href="tel:715-274-5123" class="text-[#A47E3B] hover:underline">715-274-5123</a></p>
                </div>
            </div>
        </section>

    </main>

    <footer class="bg-[#4F4A45] text-white py-6">
        <div class="container mx-auto px-6 text-center text-sm">
            <p>&copy; 2025 Interactive Trip Planner. Data sourced from the Copper Falls Camping Trip Plan.</p>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            
            const budgetData = {
                resident: {
                    'non-electric': { fees: [30, 66], total: [274, 442] },
                    'electric': { fees: [40, 90], total: [284, 472] }
                },
                'non-resident': {
                    'non-electric': { fees: [70, 96], total: [316, 492] },
                    'electric': { fees: [80, 120], total: [326, 522] }
                }
            };
            const foodCost = [60, 180];
            const fuelCost = [150, 200];
            const miscCost = [20, 50];
            const reservationFee = 7.95;

            const budgetCtx = document.getElementById('budgetChart').getContext('2d');
            let budgetChart = new Chart(budgetCtx, {
                type: 'bar',
                data: {
                    labels: ['Campsite Fees', 'Food', 'Fuel', 'Misc.'],
                    datasets: [{
                        label: 'Estimated Cost ($)',
                        data: [0,0,0,0],
                        backgroundColor: ['#6B8A7A', '#A47E3B', '#4F4A45', '#EFEBE4'],
                        borderColor: '#FDFBF8',
                        borderWidth: 2
                    }]
                },
                options: {
                    indexAxis: 'y',
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    const low = context.dataset.low[context.dataIndex];
                                    const high = context.dataset.high[context.dataIndex];
                                    label += `$${low} - $${high}`;
                                    return label;
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            beginAtZero: true,
                            title: { display: true, text: 'Cost (USD)' }
                        },
                        y: {
                            grid: { display: false }
                        }
                    }
                }
            });

            function updateBudget() {
                const residency = document.querySelector('input[name="residency"]:checked').value;
                const siteType = document.querySelector('input[name="site-type"]:checked').value;
                const data = budgetData[residency][siteType];
                
                const feesLow = data.fees[0] + reservationFee;
                const feesHigh = data.fees[1] + reservationFee;
                
                const lowData = [feesLow, foodCost[0], fuelCost[0], miscCost[0]];
                const highData = [feesHigh, foodCost[1], fuelCost[1], miscCost[1]];

                const avgData = lowData.map((low, i) => (low + highData[i]) / 2);

                budgetChart.data.datasets[0].data = avgData;
                budgetChart.data.datasets[0].low = lowData;
                budgetChart.data.datasets[0].high = highData;
                budgetChart.update();
                
                const totalLow = data.total[0];
                const totalHigh = data.total[1];
                document.getElementById('total-cost').textContent = `$${Math.round(totalLow)} - $${Math.round(totalHigh)}`;
            }

            document.getElementById('residency-toggle').addEventListener('change', updateBudget);
            document.getElementById('site-type-toggle').addEventListener('change', updateBudget);
            
            updateBudget();


            const trails = [
                { name: 'Doughboys Nature Trail', length: '1.7 mi', difficulty: 'Moderate', features: ['waterfalls'], description: 'Main trail for viewing Copper and Brownstone Falls. Pets NOT allowed.', tags: ['waterfalls', 'easy'] },
                { name: 'Red Granite Falls Trail', length: '2.5 mi', difficulty: 'Easy', features: ['waterfalls', 'pet-friendly'], description: 'The only waterfall trail open to pets. Leads to Red Granite Falls.', tags: ['waterfalls', 'pet-friendly', 'easy'] },
                { name: 'CCC 692 Trail', length: '1.0 mi', difficulty: 'Moderate', features: ['views'], description: 'Spur trail to a 65-foot observation tower with views of Lake Superior.', tags: ['views'] },
                { name: 'Meadow Trail', length: '1.5 mi', difficulty: 'Easy', features: ['pet-friendly'], description: 'Gentle loop popular for wildlife viewing. Pets allowed.', tags: ['pet-friendly', 'easy'] },
                { name: 'Takesson Trails', length: '2.5 mi', difficulty: 'Moderate', features: ['pet-friendly'], description: 'Two-loop system for hiking/biking. Passes beaver ponds. Pets allowed.', tags: ['pet-friendly'] },
                { name: 'Vahtera Trails', length: '1.7 mi', difficulty: 'Moderate', features: ['pet-friendly'], description: 'Two-loop system through hardwood and hemlock forest. Pets allowed.', tags: ['pet-friendly'] },
                { name: 'North Country Trail', length: '4.0+ mi', difficulty: 'Varies', features: ['pet-friendly'], description: 'A national scenic trail passing through the park. Pets allowed.', tags: ['pet-friendly'] },
            ];

            const trailGrid = document.getElementById('trail-grid');
            
            function renderTrails(filter = 'all') {
                trailGrid.innerHTML = '';
                const filteredTrails = filter === 'all' ? trails : trails.filter(trail => trail.tags.includes(filter));
                
                filteredTrails.forEach(trail => {
                    const trailCard = document.createElement('div');
                    trailCard.className = 'card p-6';
                    let featuresHTML = '';
                    if(trail.features.includes('waterfalls')) featuresHTML += '<span class="text-xs font-bold mr-2">🌊 WATERFALL</span>';
                    if(trail.features.includes('pet-friendly')) featuresHTML += '<span class="text-xs font-bold mr-2">🐾 PET-FRIENDLY</span>';
                    if(trail.features.includes('views')) featuresHTML += '<span class="text-xs font-bold mr-2">🔭 VIEWS</span>';

                    trailCard.innerHTML = `
                        <h4 class="font-bold text-xl mb-2">${trail.name}</h4>
                        <div class="text-sm text-[#4F4A45] mb-3">
                            <span>${trail.length}</span> &bull; <span>${trail.difficulty}</span>
                        </div>
                        <p class="text-sm mb-4">${trail.description}</p>
                        <div class="text-[#A47E3B]">${featuresHTML}</div>
                    `;
                    trailGrid.appendChild(trailCard);
                });
            }

            document.getElementById('trail-filters').addEventListener('click', function(e) {
                if(e.target.tagName === 'BUTTON') {
                    document.querySelectorAll('#trail-filters button').forEach(btn => btn.classList.remove('active'));
                    e.target.classList.add('active');
                    renderTrails(e.target.dataset.filter);
                }
            });
            
            renderTrails();

            const checklistData = {
                "Shelter & Sleeping": ["Tent & footprint", "Sleeping bags (20°F rated)", "Sleeping pads", "Camping pillows"],
                "Cooking & Dining": ["Camping stove & fuel", "Cook pots & pan", "Utensils (eating & cooking)", "Cooler & ice", "Water bottles/jug", "Biodegradable soap"],
                "Clothing": ["Moisture-wicking layers", "Quick-dry pants/shorts", "Fleece or jacket", "Rainwear (jacket & pants)", "Hiking shoes & socks", "Swimsuit"],
                "Health & Safety": ["First-aid kit", "Headlamps/flashlights", "Sunscreen & sun hat", "Bug repellent (DEET/Picaridin)", "Multi-tool or knife"],
            };

            const checklistContainer = document.getElementById('checklist-container');
            for (const category in checklistData) {
                let categoryHtml = `<div class="checklist-category">
                    <h4 class="font-semibold text-lg mb-3">${category}</h4>
                    <ul class="space-y-2">`;
                checklistData[category].forEach(item => {
                    categoryHtml += `<li>
                        <label class="flex items-center space-x-3 cursor-pointer">
                            <input type="checkbox" class="w-5 h-5 rounded border-gray-300 text-green-600 focus:ring-green-500">
                            <span>${item}</span>
                        </label>
                    </li>`;
                });
                categoryHtml += `</ul></div>`;
                checklistContainer.innerHTML += categoryHtml;
            }

            const navLinks = document.querySelectorAll('nav a[href^="#"]');
            navLinks.forEach(link => {
                link.addEventListener('click', function (e) {
                    e.preventDefault();
                    let target = document.querySelector(this.getAttribute('href'));
                    if(target){
                       window.scrollTo({
                           top: target.offsetTop - 80, 
                           behavior: 'smooth'
                       });
                    }
                });
            });

        });
    </script>
</body>
</html>
