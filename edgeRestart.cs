using System;
using System.Diagnostics;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Runtime.InteropServices;

namespace EdgeController
{
    static class Program
    {
        // マウスカーソルを強制的に変更するためのWin32 API（より確実な制御のため）
        [DllImport("user32.dll")]
        static extern bool SetCursor(IntPtr hCursor);
        [DllImport("user32.dll")]
        static extern IntPtr LoadCursor(IntPtr hInstance, int lpCursorName);

        private const int IDC_WAIT = 32514; // 砂時計カーソルのID

        [STAThread]
        static void Main()
        {
            // GUIを表示させない設定
            Application.EnableVisualStyles();
            
            // 非同期でメイン処理を実行
            Task.Run(async () =>
            {
                try
                {
                    // 1. カーソルを待機状態に設定（アプリケーション全体）
                    Application.UseWaitCursor = true;

                    // 2. Edgeのタスクキル
                    KillEdge();

                    // 3. 処理の合間にわずかな待機（OSがプロセス終了を認識するため）
                    await Task.Delay(500);

                    // 4. 引数付きでEdgeを起動
                    StartEdge("--inprivate https://www.google.com");
                }
                finally
                {
                    // 5. 終了
                    Application.UseWaitCursor = false;
                    Application.Exit();
                }
            });

            // メッセージループを開始（カーソルの変更を反映させるために必要）
            Application.Run();
        }

        private static void KillEdge()
        {
            foreach (var p in Process.GetProcessesByName("msedge"))
            {
                try
                {
                    p.Kill();
                    p.WaitForExit(2000);
                }
                catch { /* 権限不足等は無視 */ }
            }
        }

        private static void StartEdge(string args)
        {
            try
            {
                Process.Start(new ProcessStartInfo
                {
                    FileName = "msedge.exe",
                    Arguments = args,
                    UseShellExecute = true
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show($"起動エラー: {ex.Message}");
            }
        }
    }
}
