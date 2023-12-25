import HomePlanCard from "./plan_card";


export default function PlanList() {
    let plans = []

    for(let i = 0; i < 20; i++){
        plans.push({
            name : 'City Explorer Adventure',
            description: ' Dive into the heart of urban life with this city ' +
                'exploration itinerary. Discover iconic landmarks, trendy ' +
                'neighborhoods, and hidden gems that make this city unique.',
            id :'1'
        })
    }
    return (
        <div className = 'container mx-auto mt-10'>
            <div className="items-center justify-items-center grid grid-rows-4 grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4">
                {plans.map((plan) => (
                    <HomePlanCard plan={plan}></HomePlanCard>
                ))}
            </div>
        </div>
    )
}