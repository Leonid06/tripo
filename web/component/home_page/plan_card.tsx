'use client'
import {useRouter} from "next/navigation";
export default function PlanCard({ plan }) {
    const router = useRouter()
    return (
            <div onClick={()=> router.push(`/plan/${plan.id}`)} className=" h-52 flex w-52 overflow-auto bg-white rounded-2xl shadow-lg dark:bg-gray-800 mt-7">

                <div className="ml-10">
                    <h1 className="mt-6 text-xl font-bold text-gray-800 dark:text-white">
                        {plan.name}
                    </h1>

                    <p className="mt-2 text-sm text-gray-600 dark:text-gray-400">
                        {plan.description}
                    </p>
                </div>
            </div>


    )
}