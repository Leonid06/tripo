import HomePlanCard from "./plan_card";


export default function PlanList() {
    let plans = [
        {
            name : 'test name 1',
            description: 'test description 1',
            id: '1'
        },
        {
            name : 'test name 1',
            description: 'test description 1',
            id :'1'
        },
        {
            name : 'test name 1',
            description: 'test description 1',
            id :'1'
        },
        {
            name : 'test name 1',
            description: 'test description 1',
            id :'1'
        },
        {
            name : 'test name 1',
            description: 'test description 1',
            id: '1'
        },
        {
            name : 'test name 1',
            description: 'test description 1',
            id :'1'
        },
        {
            name : 'test name 1',
            description: 'test description 1',
            id :'1'
        },
        {
            name : 'test name 1',
            description: 'test description 1',
            id :'1'
        }
    ]
    return (
        <div className="grid grid-rows-3 grid-flow-col gap-x-12 gap-y-1 w-96 max-h-full">
            {plans.map((plan) => (
                <HomePlanCard plan={plan}></HomePlanCard>
            ))}
        </div>
    )
}