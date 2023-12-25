'use client'
import {useRouter} from "next/navigation";

export default function PlanCreateButton() {
    const router = useRouter()
    return (

            <div className="flex items-center justify-center mb-5">
                    <button
                        onClick={()=> router.push('/plan/create')}
                        type="button"
                        className="text-sm h-16 w-32 mt-10 text-primary_text_color bg-primary_button_color hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-2xl px-5 py-2.5 mr-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800"
                    >
                        Create plan
                    </button>
            </div>


    )
}