/*
  This script handles all the interactive functionality for the Copper Falls Trip Planner.
  It's wrapped in a DOMContentLoaded listener to ensure the HTML is ready before the script runs.
*/

document.addEventListener('DOMContentLoaded', function() {

    // --- Section 1: Interactive Budget Calculator ---
    const budgetChartElement = document.getElementById('budgetChart');
    if (budgetChartElement) {
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

        const budgetCtx = budgetChartElement.getContext('2d');
        const budgetChart = new Chart(budgetCtx, {
            type: 'bar',
            data: {
                labels: ['Campsite Fees', 'Food', 'Fuel', 'Misc.'],
                datasets: [{
                    label: 'Estimated Cost ($)',
                    data: [0, 0, 0, 0],
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
                                label += `$${low.toFixed(2)} - $${high.toFixed(2)}`;
                                return label;
                            }
                        }
                    }
                },
                scales: {
                    x: { beginAtZero: true, title: { display: true, text: 'Cost (USD)' }},
                    y: { grid: { display: false } }
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
    }

    // --- Section 2: Filterable Trail Guide ---
    const trailGrid = document.getElementById('trail-grid');
    if (trailGrid) {
        const trails = [
            { name: 'Doughboys Nature Trail', length: '1.7 mi', difficulty: 'Moderate', features: ['waterfalls'], description: 'Main trail for viewing Copper and Brownstone Falls. Pets NOT allowed.', tags: ['waterfalls', 'easy'] },
            { name: 'Red Granite Falls Trail', length: '2.5 mi', difficulty: 'Easy', features: ['waterfalls', 'pet-friendly'], description: 'The only waterfall trail open to pets. Leads to Red Granite Falls.', tags: ['waterfalls', 'pet-friendly', 'easy'] },
            { name: 'CCC 692 Trail', length: '1.0 mi', difficulty: 'Moderate', features: ['views'], description: 'Spur trail to a 65-foot observation tower with views of Lake Superior.', tags: ['views'] },
            { name: 'Meadow Trail', length: '1.5 mi', difficulty: 'Easy', features: ['pet-friendly'], description: 'Gentle loop popular for wildlife viewing. Pets allowed.', tags: ['pet-friendly', 'easy'] },
            { name: 'Takesson Trails', length: '2.5 mi', difficulty: 'Moderate', features: ['pet-friendly'], description: 'Two-loop system for hiking/biking. Passes beaver ponds. Pets allowed.', tags: ['pet-friendly'] },
            { name: 'Vahtera Trails', length: '1.7 mi', difficulty: 'Moderate', features: ['pet-friendly'], description: 'Two-loop system through hardwood and hemlock forest. Pets allowed.', tags: ['pet-friendly'] },
            { name: 'North Country Trail', length: '4.0+ mi', difficulty: 'Varies', features: ['pet-friendly'], description: 'A national scenic trail passing through the park. Pets allowed.', tags: ['pet-friendly'] },
        ];

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
            if (e.target.tagName === 'BUTTON') {
                document.querySelectorAll('#trail-filters button').forEach(btn => btn.classList.remove('active'));
                e.target.classList.add('active');
                renderTrails(e.target.dataset.filter);
            }
        });
        
        renderTrails();
    }

    // --- Section 3: Interactive Packing Checklist ---
    const checklistContainer = document.getElementById('checklist-container');
    if (checklistContainer) {
        const checklistData = {
            "Shelter & Sleeping": ["Tent & footprint", "Sleeping bags (20°F rated)", "Sleeping pads", "Camping pillows"],
            "Cooking & Dining": ["Camping stove & fuel", "Cook pots & pan", "Utensils (eating & cooking)", "Cooler & ice", "Water bottles/jug", "Biodegradable soap"],
            "Clothing": ["Moisture-wicking layers", "Quick-dry pants/shorts", "Fleece or jacket", "Rainwear (jacket & pants)", "Hiking shoes & socks", "Swimsuit"],
            "Health & Safety": ["First-aid kit", "Headlamps/flashlights", "Sunscreen & sun hat", "Bug repellent (DEET/Picaridin)", "Multi-tool or knife"],
        };

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
    }

    // --- Section 4: Smooth Scrolling for Navigation Links ---
    const navLinks = document.querySelectorAll('nav a[href^="#"]');
    navLinks.forEach(link => {
        link.addEventListener('click', function (e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - 80, // Adjust for sticky header height
                    behavior: 'smooth'
                });
            }
        });
    });

}); // This is the single, correct closing brace for the DOMContentLoaded event listener.
