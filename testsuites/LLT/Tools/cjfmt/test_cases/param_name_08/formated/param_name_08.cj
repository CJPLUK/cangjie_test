// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

public class DeploymentUtils {
    /**
     * 计算 Deployment 对应的 RS 应有的副本数，根据部署策略进行新副本数的计算
     */
    public static func newRSNewReplicas(deployment: Deployment, allRSs: ReplicaSets, newRS: ReplicaSet): Int32 {
        match {
            case (deployment.spec.strategy.`type` ==
                DeploymentStrategyType.RecreateDeploymentStrategyType) => return AccessAssit
                .getReplicas(deployment) // 直接以 deployment 副本数作为 ReplicaSet 的副本数

            case _ =>
                // 滚动更新 (DeploymentStrategyType.RollingUpdateDeploymentStrategyType)及其他（目前未支持，跟默认不设置为滚动升级保持一致）

                // 检测是否可以扩容：当前的Pod数与最大Pod数对比
                let currentPodCount = ReplicaSetUtils.getReplicaCountForReplicaSets(allRSs)
                let maxSurge = maxSurge(deployment)
                let dmReplicas = AccessAssit.getReplicas(deployment)
                let rsReplicas = AccessAssit.getReplicas(newRS)

                let maxTotalPods = dmReplicas + maxSurge
                if (currentPodCount >= maxTotalPods) {
                    // 已经超过最大Pod数，不再扩容
                    return 0
                }

                // 扩容数量不能超过目标期望副本数
                let scaleUpCount = min(maxTotalPods - currentPodCount, dmReplicas - rsReplicas)
                return (rsReplicas + scaleUpCount)
        }
    }
}
