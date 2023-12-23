import HomePlanCard from "./plan_card";


export default function PlanList() {
    let plans = []

    for(let i = 0; i < 20; i++){
        plans.push({
            name : 'test name 1',
            description: 'test description 1',
            id :'1'
        })
    }
    return (
        <div className="grid lg:grid-cols-3 justify-items-center">
            {plans.map((plan) => (
                <HomePlanCard plan={plan}></HomePlanCard>
            ))}
        </div>
    )
}