import PlanList from "../component/plan_list";
import PlanCreateButton from "../component/plan_create_button";

export default function Page(){
    return (
        <>
            <PlanList plans={plans}></PlanList>
            <PlanCreateButton></PlanCreateButton>
        </>
        )

}