(function () {
    const { createApp, ref, computed, onMounted } = Vue;

    const svg = (path) => `<svg viewBox="0 0 16 16" width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">${path}</svg>`;

    createApp({
        setup() {
            const version = '2.3.0';
            const links = {
                github: 'https://github.com/ckckh2023/TrashGo_AIRecognition',
                gitee: 'https://gitee.com/ckckh2023/TrashGo_AIRecognition',
                release: 'https://github.com/ckckh2023/TrashGo_AIRecognition/releases'
            };

            const theme = ref('light');
            const color = ref('blue');
            const activeCat = ref('recyclable');

            const colorMap = {
                blue:   { name: '蓝色', highlight: '#3dabff' },
                green:  { name: '绿色', highlight: '#9fe63d' },
                yellow: { name: '黄色', highlight: '#ff913d' }
            };

            const colorName = computed(() => colorMap[color.value].name);
            const highlightColor = computed(() => colorMap[color.value].highlight);
            const logoSrc = computed(() =>
                theme.value === 'light' ? 'assets/images/TrashGo.png' : 'assets/images/TrashGo_dark.png'
            );

            const nav = [
                { id: 'features', text: '核心功能' },
                { id: 'how', text: '识别流程' },
                { id: 'tech', text: '技术栈' },
                { id: 'categories', text: '分类一览' },
                { id: 'download', text: '下载' }
            ];

            const categories = [
                {
                    key: 'recyclable', name: '可回收物', icon: 'classified_RecyclableWaste.png',
                    color: '#3dabff', count: 74,
                    tip: '适宜回收和资源化利用的废弃物，请保持清洁干燥后投放至蓝色容器。',
                    items: ['A4纸','订书机','闹钟','碗','易拉罐','纸板','充电头','充电线','电路板','衣架','台灯','一次性筷子','电风扇','电熨斗','电动剃须刀','电磁炉','电子秤','信封','布条','灭火器','手电筒','泡沫板','吹风机','帽子','头戴式耳机','热水瓶','呼啦圈','键盘','钥匙','刀具','放大镜','保险箱','计算器','卡','打气筒','书','麦克风','手机','鼠标','手提包','裤子','插线板','枕头','塑料盆','塑料瓶','盘子','充电宝','收音机','遥控器','电饭煲','路由器','尺子','剪刀','鞋子','裙子','袜子','叉子','不锈钢管','凳子','行李箱','桌子','乒乓球拍','望远镜','保温杯','轮胎','镊子','雨伞','手表','水壶','水杯','钢丝球','木制梳子','木制切菜板','木制锅铲']
                },
                {
                    key: 'food', name: '厨余垃圾', icon: 'classified_FoodWaste.png',
                    color: '#9fe63d', count: 24,
                    tip: '易腐烂的生物质废弃物，投放前请去除包装，沥干水分后投放至绿色容器。',
                    items: ['苹果','香蕉皮','豆类','面包','白菜叶','蛋糕','辣椒','饼','火龙果','蛋挞','蛋','大蒜','圣女果','菠萝蜜','瓜子壳','蘑菇','橙子','梨','菠萝','草莓','地瓜','豆腐','番茄','西瓜皮']
                },
                {
                    key: 'hazardous', name: '有害垃圾', icon: 'classified_HazardousWaste.png',
                    color: '#ff913d', count: 7,
                    tip: '含有有毒有害物质，需投放至红色容器，注意密封防泄漏。',
                    items: ['胶水','电池','纽扣电池','LED灯泡','电池板','蓄电池','药品包装']
                },
                {
                    key: 'other', name: '其他垃圾', icon: 'classified_OtherWaste.png',
                    color: '#a0a0a0', count: 15,
                    tip: '除上述三类之外的其他生活废弃物，投放至灰色容器。',
                    items: ['一次性棉签','一次性杯子','PE塑料袋','鸡毛掸','香烟','干燥剂','滚筒纸','打火机','口罩','笔芯','验孕棒','搓澡巾','胶带','眼镜','唱片']
                }
            ];

            const activeCategoryObj = computed(() =>
                categories.find(c => c.key === activeCat.value) || categories[0]
            );

            const features = [
                { title: '垃圾分类', desc: '上传图片即可识别 4 大类 120 种细分类别，返回类别名称、置信度与投放建议。', icon: svg('<rect x="2" y="3" width="12" height="10" rx="1.5"></rect><path d="M5 6h6M5 9h4"></path>') },
                { title: '历史记录', desc: '自动记录每次识别的时间、图片、类别与建议，支持检索与删除，本地持久化。', icon: svg('<circle cx="8" cy="8" r="6"></circle><path d="M8 4.5v3.5l2.5 1.5"></path>') },
                { title: '收藏夹', desc: '收藏常用或重要的识别项，便于快速查阅投放建议，告别反复拍照。', icon: svg('<path d="M8 13.5l-4.5-3a2.8 2.8 0 0 1 0-4.2C4.7 5 6.5 5 8 6.5 9.5 5 11.3 5 12.5 6.3a2.8 2.8 0 0 1 0 4.2L8 13.5z"></path>') },
                { title: '更多功能', desc: '集成人脸检测等扩展能力，基于 OpenCV haarcascade 级联模型，持续扩展。', icon: svg('<circle cx="6" cy="6.5" r="2.5"></circle><path d="M2 13c0-2.2 1.8-4 4-4s4 1.8 4 4M10 4.5h4M12 2.5v4"></path>') },
                { title: '个性设置', desc: '明亮/黑暗主题、蓝/绿/黄三色配色、本地模型/百度云引擎切换、API Key 管理。', icon: svg('<circle cx="8" cy="8" r="2.5"></circle><path d="M8 1.5v2M8 12.5v2M1.5 8h2M12.5 8h2M3.5 3.5l1.4 1.4M11.1 11.1l1.4 1.4M12.5 3.5l-1.4 1.4M4.9 11.1l-1.4 1.4"></path>') },
                { title: '双引擎识别', desc: '本地 ONNX 模型离线识别，隐私无忧；百度云 API 在线识别，精度更高。', icon: svg('<path d="M2 5l6-3 6 3-6 3-6-3z"></path><path d="M2 5v6l6 3 6-3V5M8 8v6"></path>') }
            ];

            const steps = [
                { title: '上传图片', desc: '点击或拖拽本地图片到识别区，支持常见格式，自动预处理。' },
                { title: 'AI 识别', desc: '本地 ResNet/MobileNet ONNX 模型推理，或调用百度云 API 识别。' },
                { title: '查看结果', desc: '返回类别、置信度与投放建议，自动写入历史记录，可一键收藏。' }
            ];

            const techStack = [
                { name: 'Qt', version: '6.10.3', role: '应用框架 / QML UI', img: 'Qticon.png' },
                { name: 'OpenCV', version: '4.12.0', role: '图像处理 / DNN 推理', img: 'OpenCVicon.png' },
                { name: 'ResNet', version: '.onnx', role: '本地深度模型', emoji: '🧠' },
                { name: 'MobileNet', version: '.onnx', role: '轻量快速模型', emoji: '⚡' },
                { name: 'haarcascade', version: '级联模型', role: '人脸检测', emoji: '👤' },
                { name: '百度云 API', version: '在线识别', role: '云端高精度引擎', emoji: '☁️' },
                { name: 'CMake', version: '构建系统', role: '跨平台编译', emoji: '🔧' },
                { name: 'C++17', version: '标准', role: '核心实现语言', emoji: '⚙️' }
            ];

            const toast = ref({ show: false, text: '', type: 'info' });
            let toastTimer = null;
            function showToast(text, type = 'info') {
                toast.value = { show: true, text, type };
                if (toastTimer) clearTimeout(toastTimer);
                toastTimer = setTimeout(() => { toast.value.show = false; }, 2600);
            }

            function toggleTheme() {
                theme.value = theme.value === 'light' ? 'dark' : 'light';
                document.documentElement.setAttribute('data-theme', theme.value);
                try { localStorage.setItem('trashgo_theme', theme.value); } catch (e) { }
                showToast(theme.value === 'dark' ? '已切换至黑暗主题' : '已切换至明亮主题', 'info');
            }

            function cycleColor() {
                const order = ['blue', 'green', 'yellow'];
                const next = order[(order.indexOf(color.value) + 1) % order.length];
                color.value = next;
                document.documentElement.setAttribute('data-color', next);
                try { localStorage.setItem('trashgo_color', next); } catch (e) { }
                showToast('配色已切换为' + colorMap[next].name, 'info');
            }

            function scrollTo(id) {
                if (id === 'top') {
                    window.scrollTo({ top: 0, behavior: 'smooth' });
                } else {
                    const el = document.getElementById(id);
                    if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            }

            onMounted(() => {
                try {
                    theme.value = localStorage.getItem('trashgo_theme') || 'light';
                    color.value = localStorage.getItem('trashgo_color') || 'blue';
                } catch (e) { }
            });

            return {
                version, links, nav, categories, features, steps, techStack,
                theme, color, activeCat, toast,
                colorName, highlightColor, logoSrc, activeCategoryObj,
                toggleTheme, cycleColor, scrollTo
            };
        }
    }).mount('#app');
})();
