'use client'
import {useRouter} from "next/navigation";
import {PlusIcon} from "@heroicons/react/24/solid";

export default function PlanCreateButton() {
    const router = useRouter()
    return (

            <div className="fixed bottom-2 right-28 sm:right-14 md:right-18 lg:right-28 xl:right-12 2xl:right-14 mb-5">
                    <button
                        onClick={()=> router.push('/plan/create')}
                        type="button"
                        className="rounded-full text-sm h-16 w-16 mt-10 text-primary_text_color bg-primary_button_color hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium px-5 py-2.5 mr-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800"
                    >
                        <PlusIcon></PlusIcon>
                    </button>
            </div>


    )
}