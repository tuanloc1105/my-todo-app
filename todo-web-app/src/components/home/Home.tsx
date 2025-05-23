import React, {useEffect, useState} from "react";
import {useAppContext} from "../../context/AppProvider.tsx";
import {
    Button,
    ConfigProvider,
    DatePicker,
    FloatButton,
    GetProps,
    Input,
    Modal,
    notification,
    Table,
    TableProps,
    theme
} from 'antd';
import {MoonOutlined, PlusOutlined, SunOutlined} from "@ant-design/icons";
import {useNavigateTo} from "../../utils/navigation.ts";
import Loading from "../common/Loading.tsx";
import {ListAllTasksRequest} from "../../dto/ApiRequest.ts";
import {sendRequestJson} from "../../utils/api-utils.ts";
import {ListAllTasksResponse, TaskItem} from "../../dto/ApiResponse.ts";

// type RangePickerProps = GetProps<typeof DatePicker.RangePicker>;

const Home: React.FC = () => {
    // const {message} = App.useApp();
    const navigateTo = useNavigateTo();
    const [api, contextHolder] = notification.useNotification();
    type NotificationType = 'success' | 'info' | 'warning' | 'error';
    type SearchProps = GetProps<typeof Input.Search>;
    const {Search} = Input;
    const {lightTheme, setLightTheme} = useAppContext();
    const onSearch: SearchProps['onSearch'] = (value, _e, info) =>
        console.log(info?.source, value);
    const [loading, setLoading] = useState<boolean>(false);
    const [tasksListPageNumber, setTasksListPageNumber] = useState(1);
    const [totalTasksCount, setTotalTasksCount] = useState(0);
    const [tasksData, setTasksData] = useState<TaskItem[]>([]);
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [newTaskData, setNewTaskData] = useState({
        taskTitle: "",
        taskContent: "",
        taskRemindDate: "",
    })

    const openNotificationWithIcon = (type: NotificationType, contentL: string) => {
        api[type]({
            message: (
                <p className="font-bold font-sans">Notification</p>
            ),
            description: (
                <p className="font-sans">{contentL}</p>
            ),
        });
    };

    const showModal = () => {
        setIsModalOpen(true);
    };

    const handleOk = () => {
        console.log(newTaskData);
        setIsModalOpen(false);
    };

    const handleCancel = () => {
        setIsModalOpen(false);
    };

    const handleGetTasks = async (pageNum: number | 0): Promise<void> => {
        setLoading(true);
        try {
            const request: ListAllTasksRequest = {
                page_no: pageNum === 0 ? tasksListPageNumber : pageNum
            }
            console.log(request)
            const listAllTasksResult = await sendRequestJson<ListAllTasksResponse>(
                request,
                `${import.meta.env.VITE_BACKEND_API_URL}/tasks/list_all_tasks`,
                "POST",
                {
                    "Authorization": `Bearer ${localStorage.getItem("access_token")}`
                }
            );
            if (listAllTasksResult.code === 401) {
                navigateTo("/");
            }
            setTotalTasksCount(listAllTasksResult.response.meta.total_count);
            if (listAllTasksResult.response.meta.total_count > 0) {
                setTasksData(listAllTasksResult.response.tasks);
            }
        } catch (error) {
            console.log(error);
            openNotificationWithIcon("error", "An unexpected error occurred.");
        } finally {
            setLoading(false);
        }
    };

    // const onOk = (value: DatePickerProps['value'] | RangePickerProps['value']) => {
    //     console.log('onOk: ', value);
    // };

    useEffect(() => {
        if (!localStorage.getItem("access_token")) {
            openNotificationWithIcon("warning", "You have not logged in");
            navigateTo("/login");
        }
        handleGetTasks(0).then();
    }, []);

    const columns: TableProps<TaskItem>['columns'] = [
        {
            title: 'Task',
            dataIndex: "task_title",
            key: "task_title",
        },
        {
            title: 'Detail',
            dataIndex: "task_content",
            key: "task_content",
        },
        {
            title: 'Action',
            key: 'action',
            render: (_, record: TaskItem) => (
                <>
                    <div className="flex gap-2">
                        <Button
                            style={{
                                width: 'fit-content',
                                color: 'black',
                            }}
                            color="yellow"
                            variant="solid"
                            onClick={() => {
                                console.log(record);
                            }}
                        >
                            Button
                        </Button>
                    </div>
                </>
            )
        }
    ];

    return (
        <>
            {contextHolder}
            <div
                className={
                    (
                        lightTheme ? "bg-gradient-to-r from-purple-900 to-yellow-50" :
                            "bg-gradient-to-r from-purple-900 to-stone-900"
                    ) + " w-screen h-screen flex flex-col items-center justify-center gap-5 font-sans overflow-auto"
                }
            >
                <ConfigProvider
                    theme={{
                        token: {
                            fontFamily: "Montserrat"
                        },
                        algorithm: lightTheme ? theme.defaultAlgorithm : theme.darkAlgorithm
                    }}
                >

                    <FloatButton
                        onClick={() => showModal()}
                        icon={<PlusOutlined/>}
                    />

                    <h1 className="bg-gradient-to-r from-violet-600 to-indigo-600 bg-clip-text text-transparent text-3xl font-bold">
                        TODO LIST
                    </h1>
                    <div
                        style={{
                            maxHeight: "22px"
                        }}
                        className="flex gap-2 w-1/2"
                    >
                        <ConfigProvider
                            theme={{
                                token: {
                                    colorPrimary: "#8b5cf6", // violet-500
                                }
                            }}
                        >
                            <Search
                                style={{
                                    height: "100%",
                                }}
                                placeholder="Enter your search to find task..."
                                onSearch={onSearch}
                                enterButton
                            />
                            <Button
                                type="primary"
                                icon={lightTheme ? <MoonOutlined/> : <SunOutlined/>}
                                onClick={() => {
                                    setLightTheme(!lightTheme);
                                }}
                            />
                        </ConfigProvider>
                    </div>
                    <div className="w-1/2 overflow-auto">
                        <Table<TaskItem>
                            rowKey={'task_uid'}
                            columns={columns}
                            dataSource={tasksData}
                            scroll={{x: 'max-content'}}
                            style={{maxWidth: '100%'}}
                            pagination={{
                                current: tasksListPageNumber,
                                total: totalTasksCount,
                                pageSize: 10,
                                showTotal: (total, range) => `${range[0]}-${range[1]} of ${total} element(s)`,
                                onChange: async (page, pageSize) => {
                                    console.log("reload - " + page + " - " + pageSize);
                                    setTasksListPageNumber(page);
                                    await handleGetTasks(page);
                                },
                            }}
                        />
                    </div>
                    <ConfigProvider
                        theme={{
                            token: {
                                colorPrimary: "#8b5cf6", // violet-500
                            }
                        }}
                    >
                        <Modal
                            width="50%"
                            title="Add new task"
                            open={isModalOpen}
                            onOk={handleOk}
                            onCancel={handleCancel}
                        >
                            <div
                                className="flex flex-col gap-5 overflow-auto"
                            >
                                <Input
                                    value={newTaskData.taskTitle}
                                    onChange={(e) => {
                                        setNewTaskData(prev => ({
                                            ...prev,
                                            taskTitle: e.target.value,
                                        }));
                                    }}
                                    placeholder="Task title"/>
                                <Input
                                    value={newTaskData.taskContent}
                                    onChange={(e) => {
                                        setNewTaskData(prev => ({
                                            ...prev,
                                            taskContent: e.target.value,
                                        }));
                                    }}
                                    placeholder="Task content"/>
                                <DatePicker
                                    showTime
                                    onChange={(value, dateString) => {
                                        console.log('Selected Time: ', value);
                                        console.log('Formatted Selected Time: ', dateString);
                                        setNewTaskData(prev => ({
                                            ...prev,
                                            taskRemindDate: dateString + "",
                                        }));
                                    }}
                                    // onOk={onOk}
                                />
                            </div>
                        </Modal>
                    </ConfigProvider>
                </ConfigProvider>
                {
                    loading && <Loading/>
                }
            </div>
        </>
    );
}

export default Home;
