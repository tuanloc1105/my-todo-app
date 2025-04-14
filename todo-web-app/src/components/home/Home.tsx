import React, {useEffect} from "react";
import {useAppContext} from "../../context/AppProvider.tsx";
import {Button, ConfigProvider, GetProps, Input, notification, theme} from 'antd';
import {MoonOutlined, SunOutlined} from "@ant-design/icons";
import {useNavigateTo} from "../../utils/navigation.ts";

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

    useEffect(() => {
        if (!localStorage.getItem("access_token")) {
            openNotificationWithIcon("warning", "You have not logged in");
            navigateTo("/login");
        }
    }, [navigateTo]);

    return (
        <>
            {contextHolder}
            <div
                className={
                    (
                        lightTheme ? "bg-gradient-to-r from-purple-900 to-yellow-50" :
                            "bg-gradient-to-r from-purple-900 to-stone-900"
                    ) + " w-screen h-screen flex flex-col items-center justify-center gap-5 font-sans"
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
                </ConfigProvider>
            </div>
        </>
    );
}

export default Home;
