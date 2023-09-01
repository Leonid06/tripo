import HomePlanCard from "./plan_card";
export default function PlanList({ plans }) {
    return (
        <ul role="list" className="divide-y divide-gray-100">
            {plans.map((plan) => (
               <HomePlanCard plan={plan}></HomePlanCard>
            ))}
        </ul>
    )
}