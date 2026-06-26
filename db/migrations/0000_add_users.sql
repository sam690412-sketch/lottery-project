-- ============================================================
-- Migration 0000_add_users  (T01 / P0-A)
-- 新增 users 表作為後端身份單一真相來源。
-- 性質：ADDITIVE ONLY（僅新增）。未改動任何既有表
--       （payments / subscriptions / payment_logs / webhook_logs /
--        audit_logs / draw_history / draw_sync_log / draw_validation_log）。
-- 冪等：使用 CREATE TABLE IF NOT EXISTS，可安全套用於既有 DB。
-- 對應 Drizzle schema：db/schema.ts → export const users
-- ============================================================

CREATE TABLE IF NOT EXISTS `users` (
  `id` varchar(64) NOT NULL,
  `email` varchar(255) NOT NULL,
  `nickname` varchar(128) NOT NULL DEFAULT '',
  `password_hash` varchar(255) NOT NULL,
  `role` enum('guest','free','vip','tester','admin') NOT NULL DEFAULT 'free',
  `vip_trial_remaining` int NOT NULL DEFAULT 3,
  `daily_generate_count` int NOT NULL DEFAULT 0,
  `daily_count_date` varchar(16) NOT NULL DEFAULT '',
  `is_active` tinyint NOT NULL DEFAULT 1,
  `force_password_change` tinyint NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT (now()),
  `last_login_at` timestamp NULL,
  `updated_at` timestamp NOT NULL DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `users_id` PRIMARY KEY(`id`),
  CONSTRAINT `users_email_unique` UNIQUE(`email`)
);
--> statement-breakpoint
CREATE INDEX `idx_users_email` ON `users` (`email`);
--> statement-breakpoint
CREATE INDEX `idx_users_role` ON `users` (`role`);
