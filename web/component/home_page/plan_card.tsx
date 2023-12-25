'use client'
import {useRouter} from "next/navigation";
export default function PlanCard({ plan }) {
    const router = useRouter()
    return (
        <div>
            <button onClick={()=> router.push(`/plan/${plan.id}`)} className=" h-44 flex w-44 overflow-auto bg-primary_card_color rounded-2xl shadow-lg dark:bg-gray-800">

                <div className='container'>
                    <div className='overflow-hidden max-h-14 mr-2 ml-6 mt-4'>
                        <p className="line-clamp-2 text-left text-lg font-bold text-primary_text_color">
                            {plan.name}
                        </p>
                    </div>
                    <div className='max-h-20 overflow-hidden mt-1 mr-2 ml-6'>
                        <p className="line-clamp-4 text-left text-sm text-secondary_text_color">
                            {plan.description}
                        </p>
                    </div>
                </div>
            </button>
        </div>


    )
}